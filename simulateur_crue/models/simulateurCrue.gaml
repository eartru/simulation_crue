/**
* Name: simulateurCrue
* Author: estelle
* Description: 
* Tags: Tag1, Tag2, TagN
*/

model simulateurCrue

/* Insert your model definition here */

global {
	int grid_size <- 60;
	int nb_batiment <- 50;
	int nb_evacuation <- 2;
	int nb_civil <- 1000;
	int nb_ville <- 1;
	int init_sante <- 100;
	float max_niveau_eau <- 10.0;
	bool is_river <- false;
	list<point> batiment_point <- [{25, 90 }, { 40, 78 }, { 21, 86 }, { 41, 64 }, { 10, 82 }, {25, 95 }, { 40, 92 }, { 21, 82 }, { 41, 84 }, { 10, 68 },
		{25, 50}, { 33, 66 }, { 21, 77 }, { 12, 64 }, { 17, 55 }, {27, 83 }, { 50, 75 }, { 21, 72 }, { 41, 89 }, { 44, 59 },
		{8, 50}, { 11, 55 }, { 20, 63 }, { 12, 54 }, { 17, 55 }, {7, 83 }, { 15, 62 }, { 21, 53 }, { 16, 59 }, { 13, 61 },
		{25, 77}, { 33, 76 }, { 42, 87 }, { 46, 90 }, { 49, 82 }, {50, 83 }, { 44, 75 }, { 28, 71 }, { 30, 88 }, { 38, 66 }];
		
	file river_shapefile <- file("../includes/RedRiver.shp");
		
	list<point> evacuation_point <- [{5, 90 }, { 50, 90 }, {5, 50}, {25, 90}];
   	
	init {
		create batiment number: nb_batiment;
		create evacuation_building number: nb_evacuation;
		create civil number: nb_civil{
			target <- one_of (evacuation_building) ; 
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

species evacuation_building {
	point my_plot;
	init {
		my_plot <- one_of(evacuation_point);
		location <- any_location_in(my_plot);
	}
	aspect square{
		draw square(4) color: #red;
	}	
}

species batiment {
	point my_plot;
	init {
		my_plot <- one_of(batiment_point);
		//location <- my_plot.location;
		location <- any_location_in(my_plot);
	}	
	
	aspect square{
		draw square(3) color: #black;
	}	
}

species humain skills: [moving]{
	evacuation_building target;
	civil other_people;
	batiment other_batiment;
	batiment my_plot;
	init {
		my_plot <- one_of(batiment);
		location <- my_plot.location;
	}	
	
	reflex goto {
		do goto on:plot target:target speed:0.5;
	}
}

species civil parent: humain{
	int sante <- init_sante;
	bool est_mort <- false;
	reflex baisse_sante {
		sante <- sante -1;
		
		if (sante = 0) {
			est_mort <- true;
		}
	}
	
	aspect circle{
		draw circle(0.8) color: #green;
	}
}

species secouriste parent: humain{
	aspect circle{
		draw circle(1) color: #red;
	}
}

experiment exp_name type: gui {
	
	output {
		display ville {
			grid plot lines: #black;
			species batiment aspect: square;
			species civil aspect: circle;
			species evacuation_building aspect: square;
		}
	}
}