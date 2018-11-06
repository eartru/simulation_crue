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
	int nb_batiment <- 3;
	int nb_civil <- 10;
	int nb_ville <- 1;
	int init_sante <- 100;
	float max_niveau_eau <- 10.0;
	init {
		create batiment number: nb_batiment;
		create civil number: nb_civil;
		create ville number: nb_ville;
	}
}

grid plot height: grid_size width: grid_size neighbors: 8{
	float ville;
	float niveau_eau;
	
	/*rgb color <- rgb(255*(1-niveau_eau/max_niveau_eau), 255*(1-niveau_eau/max_niveau_eau), 255) 
		update: rgb(255*(1-niveau_eau/max_niveau_eau), 255*(1-niveau_eau/max_niveau_eau), 255);*/
	
	init{
		niveau_eau <- rnd(max_niveau_eau);
		color <- rgb(255*(1-niveau_eau/max_niveau_eau), 255*(1-niveau_eau/max_niveau_eau), 255);
	}
	
	aspect plotNiveauEau {
		draw square(1) color: color /*rgb(255*(1-niveau_eau/max_niveau_eau), 255*(1-niveau_eau/max_niveau_eau), 255)*/;
	}
}

species ville {
	init {
		location <- {30, 60, 0};
	}
	aspect square {
		draw square(60) color: #white border: #red;
	}
}

species batiment {
	plot my_plot;
	init {
		my_plot <- one_of(ville);
		location <- my_plot.location;
	}	
	
	aspect square{
		draw square(3) color: #black;
	}	
}

species humain {
	plot my_plot;
	init {
		my_plot <- one_of(plot);
		location <- my_plot.location;
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
			species ville aspect: square;
		}

	}
}