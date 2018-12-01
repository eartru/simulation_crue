/*
 *  Author : Estelle
 * Description : final simulation of a river flooding next to a town that should evacuate on the user interaction (crisis manager)
 */

/** Inspired by the model of :
 * 
* Name: Hydrological Model
* Author: Patrick Taillandier
* Description: A model showing how to represent a flooding system with dykes and buildings. It uses 
* 	a grid to discretize space, and has a 3D display. The water can flow from one cell to another considering 
* 	the height of the cells, and the water pressure. It is also possible to delete dyke by clicking on one of them 
* 	in the display.
* Tags: shapefile, gis, grid, 3d, gui, hydrology
*/

model hydro

global {
	//ours
	int nb_batiment <- 50;
	int nb_evacuation <- 3;
	int nb_civil <- 1000;
	int nb_secouriste <- 50;
	int nb_rescue_building <- 2;
	int nb_sensible_building <- 5;
	int init_sante <- 100;
	int nb_morts <- 0;
	float max_niveau_eau <- 10.0;
	bool is_river <- false;
	bool evacuate <- false;
	list<point> batiment_point <- [{600, 3600 ,0.1}, { 600, 4000 ,0.1}, { 600, 4400 ,0.1}, { 600, 4800 ,0.1}, { 600, 4000 ,0.1}, {600, 4200 ,0.1}, { 600, 4400 ,0.1}, { 600, 4600 ,0.1}, { 600, 4800 ,0.1}, { 600, 3800,0.1 },
{700, 3600 ,0.1}, { 700, 4000 ,0.1}, { 700, 4400 ,0.1}, { 700, 4800 ,0.1}, { 700, 4000 ,0.1}, {700, 4200 ,0.1}, { 700, 4400 ,0.1}, { 700, 4600 ,0.1}, { 700, 4800 ,0.1}, { 700, 3800,0.1 },
{800, 3600 ,0.1}, { 800, 4000 ,0.1}, { 800, 4400 ,0.1}, { 800, 4800 ,0.1}, { 800, 4000 ,0.1}, {800, 4200 ,0.1}, { 800, 4400 ,0.1}, { 800, 4600 ,0.1}, { 800, 4800 ,0.1}, { 800, 3800,0.1 },
{900, 3600 ,0.1}, { 900, 4000 ,0.1}, { 900, 4400 ,0.1}, { 900, 4800 ,0.1}, { 900, 4000 ,0.1}, {900, 4200 ,0.1}, { 900, 4400 ,0.1}, { 900, 4600 ,0.1}, { 900, 4800 ,0.1}, { 900, 3800,0.1 },
{1000, 3600 ,0.1}, { 1000, 4000 ,0.1}, { 1000, 4400 ,0.1}, { 1000, 4800 ,0.1}, { 1000, 4000 ,0.1}, {1000, 4200 ,0.1}, { 1000, 4400 ,0.1}, { 1000, 4600 ,0.1}, { 1000, 4800 ,0.1}, { 1000, 3800,0.1 },
{1100, 3600 ,0.1}, { 1100, 4000 ,0.1}, { 1100, 4400 ,0.1}, { 1100, 4800 ,0.1}, { 1100, 4000 ,0.1}, {1100, 4200 ,0.1}, { 1100, 4400 ,0.1}, { 1100, 4600 ,0.1}, { 1100, 4800 ,0.1}, { 1100, 3800,0.1 },
{1200, 3600 ,0.1}, { 1200, 4000 ,0.1}, { 1200, 4400 ,0.1}, { 1200, 4800 ,0.1}, { 1200, 4000 ,0.1}, {1200, 4200 ,0.1}, { 1200, 4400 ,0.1}, { 1200, 4600 ,0.1}, { 1200, 4800 ,0.1}, { 1200, 3800,0.1 },
{1300, 3600 ,0.1}, { 1300, 4000 ,0.1}, { 1300, 4400 ,0.1}, { 1300, 4800 ,0.1}, { 1300, 4000 ,0.1}, {1300, 4200 ,0.1}, { 1300, 4400 ,0.1}, { 1300, 4600 ,0.1}, { 1300, 4800 ,0.1}, { 1300, 3800,0.1 },
{1400, 3600 ,0.1}, { 1400, 4000 ,0.1}, { 1400, 4400 ,0.1}, { 1400, 4800 ,0.1}, { 1400, 4000 ,0.1}, {1400, 4200 ,0.1}, { 1400, 4400 ,0.1}, { 1400, 4600 ,0.1}, { 1400, 4800 ,0.1}, { 1400, 3800,0.1 },
{1500, 3600 ,0.1}, { 1500, 4000 ,0.1}, { 1500, 4400 ,0.1}, { 1500, 4800 ,0.1}, { 1500, 4000 ,0.1}, {1500, 4200 ,0.1}, { 1500, 4400 ,0.1}, { 1500, 4600 ,0.1}, { 1500, 4800 ,0.1}, { 1500, 3800,0.1 },
{1600, 3600 ,0.1}, { 1600, 4000 ,0.1}, { 1600, 4400 ,0.1}, { 1600, 4800 ,0.1}, { 1600, 4000 ,0.1}, {1600, 4200 ,0.1}, { 1600, 4400 ,0.1}, { 1600, 4600 ,0.1}, { 1600, 4800 ,0.1}, { 1600, 3800,0.1 },
{1700, 3600 ,0.1}, { 1700, 4000 ,0.1}, { 1700, 4400 ,0.1}, { 1700, 4800 ,0.1}, { 1700, 4000 ,0.1}, {1700, 4200 ,0.1}, { 1700, 4400 ,0.1}, { 1700, 4600 ,0.1}, { 1700, 4800 ,0.1}, { 1700, 3800,0.1 },
{1800, 3600 ,0.1}, { 1800, 4000 ,0.1}, { 1800, 4400 ,0.1}, { 1800, 4800 ,0.1}, { 1800, 4000 ,0.1}, {1800, 4200 ,0.1}, { 1800, 4400 ,0.1}, { 1800, 4600 ,0.1}, { 1800, 4800 ,0.1}, { 1800, 3800,0.1 },
{1900, 3600 ,0.1}, { 1900, 4000 ,0.1}, { 1900, 4400 ,0.1}, { 1900, 4800 ,0.1}, { 1900, 4000 ,0.1}, {1900, 4200 ,0.1}, { 1900, 4400 ,0.1}, { 1900, 4600 ,0.1}, { 1900, 4800 ,0.1}, { 1900, 3800,0.1 },
{2000, 3600 ,0.1}, { 2000, 4000 ,0.1}, { 2000, 4400 ,0.1}, { 2000, 4800 ,0.1}, { 2000, 4000 ,0.1}, {2000, 4200 ,0.1}, { 2000, 4400 ,0.1}, { 2000, 4600 ,0.1}, { 2000, 4800 ,0.1}, { 2000, 3800,0.1 },
{2100, 3600 ,0.1}, { 2100, 4000 ,0.1}, { 2100, 4400 ,0.1}, { 2100, 4800 ,0.1}, { 2100, 4000 ,0.1}, {2100, 4200 ,0.1}, { 2100, 4400 ,0.1}, { 2100, 4600 ,0.1}, { 2100, 4800 ,0.1}, { 2100, 3800,0.1 }];
	//problem : multiple building on one point...
		
   list<point> evacuation_point <- [{500, 3000 ,0.1}, { 500, 5000 , 0.1}, {2200, 5000 , 0.1}];
	
   bool parallel <- true;
   //Shapefile for the river
   file river_shapefile <- file("../includes/RedRiver.shp");
   //Shapefile for the dykes
   file dykes_shapefile <- file("../includes/Dykes.shp");
   //Data elevation file
   file dem_file <- file("../includes/mnt50.asc");  
   //Diffusion rate
   float diffusion_rate <- 0.6;
   //Height of the dykes
   float dyke_height <- 15.0;
   //Width of the dyke
   float dyke_width <- 15.0;
    
   //Shape of the environment using the dem file
   geometry shape <- envelope(dem_file);
   
   //List of the drain and river cells
   list<cell> drain_cells;
   list<cell> river_cells;
   
   
  
   float step <- 1°h;
   
   init {
   	 //Initialization of the cells
      do init_cells;
     //Initialization of the water cells
      do init_water;
     //Initialization of the river cells
     river_cells <- cell where (each.is_river);
     //Initialization of the drain cells
      drain_cells <- cell where (each.is_drain);
     //Initialization of the obstacles (buildings and dykes)
      do init_obstacles;
      //Set the height of each cell
      ask cell parallel: parallel{
         obstacle_height <- compute_highest_obstacle();
         do update_color;
      }
      create batiment number: nb_batiment;
		create evacuation_building number: nb_evacuation;
		create sensible_building number: nb_sensible_building;
		create rescue_building number: nb_rescue_building;
		create civil number: nb_civil{
			target <-  one_of (evacuation_building);
		}
		create secouriste number: nb_secouriste{
			people_in_danger <- one_of(civil) ; 
		}
   }
   //Action to initialize the altitude value of the cell according to the dem file
   action init_cells {
      ask cell parallel: parallel {
         altitude <- grid_value;
         neighbour_cells <- (self neighbors_at 1) ;
      }
   }
   //action to initialize the water cells according to the river shape file and the drain
   action init_water {
      geometry river <- geometry(river_shapefile);
      ask cell overlapping river parallel: parallel {
         water_height <- 10.0;
         is_river <- true;
         is_drain <- grid_y = matrix(cell).rows - 1;
      }
   }
   //initialization of the obstacles (the buildings and the dykes)
   action init_obstacles{
      create dyke from: dykes_shapefile;
      ask dyke parallel: parallel {
          shape <-  shape + dyke_width;
            do update_cells;
      }
   }
   //Reflex to add water among the water cells
   reflex adding_input_water {
   	  float water_input <- rnd(100)/100;
      ask river_cells parallel: parallel{
         water_height <- water_height + water_input;
      }
   }
   //Reflex to flow the water according to the altitute and the obstacle
   reflex flowing {
      ask (cell sort_by ((each.altitude + each.water_height + each.obstacle_height))) parallel: parallel {
      	already <- false;
         do flow;
      }
   }
   //Reflex to update the color of the cell
   reflex update_cell_color {
      ask cell parallel: parallel {
         do update_color;
      }
   }
   //Reflex for the drain cells to drain water
   reflex draining {
      ask drain_cells parallel: parallel{
         water_height <- 0.0;
      }
   }
   
}

species batiment parent: obstacle{
	point my_cell;
	init {
		my_cell <- one_of(batiment_point);
		location <- any_location_in(my_cell);
	}	
	
	aspect square{
		draw square(50) color: #black;
	}	
}

species evacuation_building parent: batiment {
	init {
		my_cell <- one_of(evacuation_point);
		location <- any_location_in(my_cell);
	}
	
	aspect square{
		draw square(70) color: #red;
	}	
}

species sensible_building parent: batiment {
	bool is_sensible <- true;
	
	aspect square{
		draw square(70) color: #violet;
	}	
}

species rescue_building parent: batiment {
	aspect square{
		draw square(70) color: #green;
	}	
}	


species humain skills: [moving]{
	evacuation_building target;
	civil target_people;
	batiment my_cell;
	
	init {
		my_cell <- one_of(batiment);
		location <- my_cell.location;
	}	
}

species civil parent: humain{
	int sante <- init_sante;
	bool is_in_water <- false;
	
	//Not working for now
	//reflex is_drowning when: self.location = eau_species.location {
	//	is_in_water <- true;
	//}
	
	//reflex is_safe when: self.location != eau_species.location {
	//	is_in_water <- false;
	//}
		
	// reflex goto_other_building
	
	reflex goto when: evacuate = true {
		do goto on:cell target:target speed:0.1;
	}
	
	reflex baisse_sante when: is_in_water = true {
		sante <- sante -1;
		if (sante = 0) {
			nb_morts <- nb_morts +1;
			do die;
		}
	}
	
	aspect circle{
		draw circle(20) color: #yellow;
	}
}

species secouriste parent: humain{
	civil people_in_danger;
	rescue_building rescue_cell;
	
	init {
		rescue_cell <- one_of(rescue_building);
		location <- rescue_cell.location;
	}	

	aspect circle{
		draw circle(20) color: #red;
	}
	
	reflex do_rescue {
		do goto on:cell target:people_in_danger speed:0.1;
	}
}

//Species which represent the obstacle
   species obstacle parallel: parallel {
   	  //height of the obstacle
      float height min: 0.0;
      //Color of the obstacle
      rgb color;
      //Pressure of the water
      float water_pressure update: compute_water_pressure();
      
      //List of cells concerned
      list<cell> cells_concerned ;
      //List of cells in the neighbourhood 
      list<cell> cells_neighbours;
      
      //Action to compute the water pressure
      float compute_water_pressure {
      	//If the obstacle doesn't have height, then there will be no pressure
         if (height = 0.0) {
            return 0.0;
         } else {
         	//The leve of the water is equals to the maximul level of water in the neighbours cells
            float water_level <- cells_neighbours max_of (each.water_height);
            //Return the water pressure as the minimal value between 1 and the water level divided by the height
            return min([1.0,water_level / height]);
         } 
      }
      
      //Action to update the cells
      action update_cells {
      	//All the cells concerned by the obstacle are the ones overlapping the obstacle
         cells_concerned <- (cell overlapping self);
        	ask cells_concerned {
        	//Add the obstacles to the obstacles of the cell
            add myself to: obstacles;
            water_height <- 0.0;
         }
         //Cells neighbours are all the neighbours cells of the cells concerned
         cells_neighbours <- cells_concerned + cells_concerned accumulate (each.neighbour_cells);
         //The height is now computed
      	 do compute_height();
         if (height > 0.0) {   
         	//We compute the water pressure again
            water_pressure <- compute_water_pressure();
         } else {water_pressure <- 0.0;}
      }
      action compute_height;
      aspect geometry {
         int val <- int( 255 * water_pressure);
         color <- rgb(val,255-val,0);
         draw shape color: color depth: height*5 border: color;
      }
   }
   //Species buildings which is derivated from obstacle
   species buildings parent: obstacle schedules: [] {
   	 //The building has a height randomly chosed between 2 and 10
      float height <- 2.0 + rnd(8);
   }
   //Species dyke which is derivated from obstacle
   species dyke parent: obstacle parallel: parallel {
   	
       int counter_wp <- 0;
       int breaking_threshold <- 24;
      
      //Action to represent the break of the dyke
       action break{
         ask cells_concerned  {
            do update_after_destruction(myself);
         }
         do die;
      }
      //Action to compute the height of the dyke as the dyke_height without the mean height of the cells it overlaps
      action compute_height
       {
      	   height <- dyke_height - mean(cells_concerned collect (each.altitude));
      
      }
      
      //Reflex to break the dynamic of the water
      reflex breaking_dynamic {
      	if (water_pressure = 1.0) {
      		counter_wp <- counter_wp + 1;
      		if (counter_wp > breaking_threshold) {
      			do break;
      		}
      	} else {
      		counter_wp <- 0;
      	}
      }
      //user command which allows the possibility to destroy the dyke for the user
      user_command "Destroy dyke" action: break; 
   }
   //Grid cell to discretize space, initialized using the dem file
   grid cell file: dem_file neighbors: 8 frequency: 0  use_regular_agents: false use_individual_shapes: false use_neighbors_cache: false schedules: [] parallel: parallel {
      //Altitude of the cell
      float altitude;
      //Height of the water in the cell
      float water_height <- 0.0 min: 0.0;
      //Height of the cell
      float height;
      //List of the neighbour cells
      list<cell> neighbour_cells ;
      //Boolean to know if it is a drain cell
      bool is_drain <- false;
      //Boolean to know if it is a river cell
      bool is_river <- false;
      //List of all the obstacles overlapping the cell
      list<obstacle> obstacles;
      //Height of the obstacles
      float obstacle_height <- 0.0;
      bool already <- false;
      
      //Action to compute the highest obstacle among the obstacles
      float compute_highest_obstacle {
         if (empty(obstacles))
         {
            return 0.0; 
         } else {
            return obstacles max_of(each.height);
         }
      }
      //Action to flow the water 
      action flow {
      	//if the height of the water is higher than 0 then, it can flow among the neighbour cells
         if (water_height > 0) {
         	//We get all the cells already done
            list<cell> neighbour_cells_al <- neighbour_cells where (each.already);
            //If there are cells already done then we continue
            if (!empty(neighbour_cells_al)) {
               //We compute the height of the neighbours cells according to their altitude, water_height and obstacle_height
               ask neighbour_cells_al {height <- altitude + water_height + obstacle_height;}
               //The height of the cell is equals to its altitude and water height
               height <-  altitude +  water_height;
               //The water of the cells will flow to the neighbour cells which have a height less than the height of the actual cell
               list<cell> flow_cells <- (neighbour_cells_al where (height > each.height)) ;
               //If there are cells, we compute the water flowing
               if (!empty(flow_cells)) {
                  loop flow_cell over: shuffle(flow_cells) sort_by (each.height){
                     float water_flowing <- max([0.0, min([(height - flow_cell.height), water_height * diffusion_rate])]); 
                     water_height <- water_height - water_flowing;
                     flow_cell.water_height <-flow_cell.water_height +  water_flowing;
                     height <- altitude + water_height;
                  }   
               }
            }
         }
         already <- true;
      }  
      //Update the color of the cell
      action update_color { 
         int val_water <- 0;
         val_water <- max([0, min([255, int(255 * (1 - (water_height / 12.0)))])]) ;  
         color <- rgb([val_water, val_water, 255]);
         grid_value <- water_height + altitude;
      }
      //action to compute the destruction of the obstacle
      action update_after_destruction(obstacle the_obstacle){
         remove the_obstacle from: obstacles;
         obstacle_height <- compute_highest_obstacle();
      }
       
   }


experiment main_gui type: gui {
   parameter "Nombre de civils" var: nb_civil;
	parameter "Nombre de secouristes" var: nb_secouriste;
	user_command "Démarrer l'évacuation" {
		evacuate <- true;
	}
   output { 
      display map type: opengl {
         	grid cell triangulation: true;
         	species buildings aspect: geometry refresh: false;
         	species dyke aspect: geometry ;
            species batiment aspect: square;
			species civil aspect: circle;
			species secouriste aspect: circle;
			species rescue_building aspect: square;
			species sensible_building aspect: square;
			species evacuation_building aspect: square;
      }
   }
}