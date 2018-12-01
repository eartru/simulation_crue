/**
* Name: simulateurCrue
* Author: estelle
* Description:  first part of the project -> simulate the evacuation for a town with minimal properties
* Tags: Tag1, Tag2, TagN
*/

model simulateurCrue


global {
	int grid_size <- 60;
	int nb_batiment <- 50;
	int nb_evacuation <- 2;
	int nb_civil <- 1000;
	int nb_secouriste <- 50;
	int nb_rescue_building <- 2;
	int init_sante <- 100;
	int nb_morts <- 0;
	float max_niveau_eau <- 10.0;
	bool is_river <- false;
	bool evacuate <- false;
	list<point> batiment_point <- [{25, 90 }, { 40, 78 }, { 21, 86 }, { 41, 64 }, { 10, 82 }, {25, 95 }, { 56, 92 }, { 21, 82 }, { 60, 84 }, { 10, 68 },
		{25, 50}, { 33, 66 }, { 21, 77 }, { 12, 64 }, { 17, 55 }, {27, 83 }, { 50, 75 }, { 21, 72 }, { 41, 89 }, { 44, 59 },
		{8, 50}, { 11, 55 }, { 20, 63 }, { 12, 54 }, { 17, 55 }, {7, 83 }, { 15, 62 }, { 21, 53 }, { 16, 59 }, { 13, 61 },
		{25, 77}, { 33, 76 }, { 42, 87 }, { 46, 90 }, { 54, 82 }, {66, 83 }, { 62, 75 }, { 52, 71 }, { 54, 88 }, { 38, 66 }];
	//problem : multiple building on one point...
		
	file river_shapefile <- file("../includes/RedRiver.shp");
		
	list<point> evacuation_point <- [{5, 95 }, { 50, 95 }, {5, 50}, {25, 95}];
	
   	
	init {
		create batiment number: nb_batiment;
		create evacuation_building number: nb_evacuation;
		create evacuation_building number: nb_rescue_building;
		create civil number: nb_civil{
			target <-  one_of (evacuation_building);
		}
		create secouriste number: nb_secouriste{
			people_in_danger <- one_of(civil) ; 
		}
		create river from: river_shapefile;
		create eau {
			river rv <- one_of(river);
			location <- any_location_in(rv);
		} 
	}
}

grid plot height: grid_size width: grid_size neighbors: 8{
	float ville;
	float niveau_eau;
	
	init{
	//	niveau_eau <- rnd(max_niveau_eau);
	//	color <- rgb(255*(1-niveau_eau/max_niveau_eau), 255*(1-niveau_eau/max_niveau_eau), 255);
	}
	
	aspect plotNiveauEau {
	//	draw square(1) color: color;
	}
}

species batiment {
	point my_plot;
	init {
		my_plot <- one_of(batiment_point);
		location <- any_location_in(my_plot);
	}	
	
	aspect square{
		draw square(3) color: #black;
	}	
}

species evacuation_building parent: batiment {
	init {
		my_plot <- one_of(evacuation_point);
		location <- any_location_in(my_plot);
	}
	
	aspect square{
		draw square(4) color: #red;
	}	
}

species sensible_building parent: batiment {
	bool is_sensible <- true;
	
	aspect square{
		draw square(3) color: #violet;
	}	
}

species rescue_building parent: batiment {
	aspect square{
		draw square(3) color: #green;
	}	
}	


species river {
	init {
		location <- any_location_in(one_of(river_shapefile));
	}	
}

species eau {
	float niveau_eau;
	river my_plot;
	
	init {
		my_plot <- one_of(river);
		location <- any_location_in(my_plot);
		niveau_eau <- rnd(max_niveau_eau);
		color <- rgb(255*(1-niveau_eau/max_niveau_eau), 255*(1-niveau_eau/max_niveau_eau), 255);
	}	
	
	aspect square{
		draw square(1) color: color;
	}	
}

species humain skills: [moving]{
	evacuation_building target;
	civil target_people;
	batiment target_building;
	batiment my_plot;
	
	init {
		my_plot <- one_of(batiment);
		location <- my_plot.location;
	}	
	
	reflex goto_building {
		do goto on:plot target:target_building speed:0.5;
	}
	
	reflex goto when: evacuate = true {
		do goto on:plot target:target speed:0.5;
	}
}

species civil parent: humain{
	int sante <- init_sante;
	bool is_in_water <- false;
	eau eau_species;
	
	//Not working for now
	//reflex is_drowning when: self.location = eau_species.location {
	//	is_in_water <- true;
	//}
	
	//reflex is_safe when: self.location != eau_species.location {
	//	is_in_water <- false;
	//}
	
	reflex baisse_sante when: is_in_water = true {
		sante <- sante -1;
		if (sante = 0) {
			nb_morts <- nb_morts +1;
			do die;
		}
	}
	
	aspect circle{
		draw circle(0.8) color: #yellow;
	}
}

species secouriste parent: humain{
	civil people_in_danger;
	rescue_building rescue_plot;

	aspect circle{
		draw circle(0.9) color: #red;
	}
	
	reflex do_rescue {
		do goto on:plot target:people_in_danger speed:0.1;
	}
}

experiment exp_name type: gui {
	parameter "Nombre de civils" var: nb_civil;
	parameter "Nombre de secouristes" var: nb_secouriste;
	user_command "Démarrer l'évacuation" {
		evacuate <- true;
	}
	output {
		display ville {
			grid plot lines: #black;
			species batiment aspect: square;
			species civil aspect: circle;
			species secouriste aspect: circle;
			species rescue_building aspect: square;
			species evacuation_building aspect: square;
			species river;
			species eau aspect: square;
		}
	}
}