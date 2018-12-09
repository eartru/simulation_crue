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
	// Init global variables
	int nb_citizen <- 1000;
	int nb_rescuer <- 50;	
	bool evacuate <- false;
	bool evacuate_sensitive_bulding <- false;
	int nb_building <- 50;
	int nb_rescue_building <- 2;
	int nb_sensible_building <- 5;
	int nb_destroy_building <- 0;
	int nb_death <- 0;
	int prior_sensible <- 0;
	list<point> building_point <- [{825, 3675 ,0.1}, { 825, 4075 ,0.1}, { 825, 4475 ,0.1}, { 825, 4875 ,0.1}, { 825, 4075 ,0.1}, {825, 4275 ,0.1}, { 825, 4475 ,0.1}, { 825, 4675 ,0.1}, { 825, 4875 ,0.1}, { 825, 3875,0.1 },
{925, 3675 ,0.1}, { 925, 4075 ,0.1}, { 925, 4475 ,0.1}, { 925, 4875 ,0.1}, { 925, 4075 ,0.1}, {925, 4275 ,0.1}, { 925, 4475 ,0.1}, { 925, 4675 ,0.1}, { 925, 4875 ,0.1}, { 925, 3875,0.1 },
{1025, 3675 ,0.1}, { 1025, 4075 ,0.1}, { 1025, 4475 ,0.1}, { 1025, 4875 ,0.1}, { 1025, 4075 ,0.1}, {1025, 4275 ,0.1}, { 1025, 4475 ,0.1}, { 1025, 4675 ,0.1}, { 1025, 4875 ,0.1}, { 1025, 3875,0.1 },
{1125, 3675 ,0.1}, { 1125, 4075 ,0.1}, { 1125, 4475 ,0.1}, { 1125, 4875 ,0.1}, { 1125, 4075 ,0.1}, {1125, 4275 ,0.1}, { 1125, 4475 ,0.1}, { 1125, 4675 ,0.1}, { 1125, 4875 ,0.1}, { 1125, 3875,0.1 },
{1225, 3675 ,0.1}, { 1225, 4075 ,0.1}, { 1225, 4475 ,0.1}, { 1225, 4875 ,0.1}, { 1225, 4075 ,0.1}, {1225, 4275 ,0.1}, { 1225, 4475 ,0.1}, { 1225, 4675 ,0.1}, { 1225, 4875 ,0.1}, { 1225, 3875,0.1 },
{1325, 3675 ,0.1}, { 1325, 4075 ,0.1}, { 1325, 4475 ,0.1}, { 1325, 4875 ,0.1}, { 1325, 4075 ,0.1}, {1325, 4275 ,0.1}, { 1325, 4475 ,0.1}, { 1325, 4675 ,0.1}, { 1325, 4875 ,0.1}, { 1325, 3875,0.1 },
{1425, 3675 ,0.1}, { 1425, 4075 ,0.1}, { 1425, 4475 ,0.1}, { 1425, 4875 ,0.1}, { 1425, 4075 ,0.1}, {1425, 4275 ,0.1}, { 1425, 4475 ,0.1}, { 1425, 4675 ,0.1}, { 1425, 4875 ,0.1}, { 1425, 3875,0.1 },
{1525, 3675 ,0.1}, { 1525, 4075 ,0.1}, { 1525, 4475 ,0.1}, { 1525, 4875 ,0.1}, { 1525, 4075 ,0.1}, {1525, 4275 ,0.1}, { 1525, 4400 ,0.1}, { 1525, 4675 ,0.1}, { 1525, 4875 ,0.1}, { 1525, 3875,0.1 },
{1625, 3675 ,0.1}, { 1625, 4075 ,0.1}, { 1625, 4475 ,0.1}, { 1625, 4875 ,0.1}, { 1625, 4075 ,0.1}, {1625, 4275 ,0.1}, { 1625, 4400 ,0.1}, { 1625, 4675 ,0.1}, { 1625, 4875 ,0.1}, { 1625, 3875,0.1 },
{1725, 3675 ,0.1}, { 1725, 4075 ,0.1}, { 1725, 4475 ,0.1}, { 1725, 4875 ,0.1}, { 1725, 4075 ,0.1}, {1725, 4275 ,0.1}, { 1725, 4400 ,0.1}, { 1725, 4675 ,0.1}, { 1725, 4875 ,0.1}, { 1725, 3875,0.1 },
{1825, 3675 ,0.1}, { 1825, 4075 ,0.1}, { 1825, 4475 ,0.1}, { 1825, 4875 ,0.1}, { 1825, 4075 ,0.1}, {1825, 4275 ,0.1}, { 1825, 4400 ,0.1}, { 1825, 4675 ,0.1}, { 1825, 4875 ,0.1}, { 1825, 3875,0.1 },
{1925, 3675 ,0.1}, { 1925, 4075 ,0.1}, { 1925, 4475 ,0.1}, { 1925, 4875 ,0.1}, { 1925, 4075 ,0.1}, {1925, 4275 ,0.1}, { 1925, 4400 ,0.1}, { 1925, 4675 ,0.1}, { 1925, 4875 ,0.1}, { 1925, 3875,0.1 },
{2025, 3675 ,0.1}, { 2025, 4075 ,0.1}, { 2025, 4475 ,0.1}, { 2025, 4875 ,0.1}, { 2025, 4075 ,0.1}, {2025, 4275 ,0.1}, { 2025, 4400 ,0.1}, { 2025, 4675 ,0.1}, { 2025, 4875 ,0.1}, { 2025, 3875,0.1 },
{2125, 3675 ,0.1}, { 2125, 4075 ,0.1}, { 2125, 4475 ,0.1}, { 2125, 4875 ,0.1}, { 2125, 4075 ,0.1}, {2125, 4275 ,0.1}, { 2125, 4400 ,0.1}, { 2125, 4675 ,0.1}, { 2125, 4875 ,0.1}, { 2125, 38750,0.1 },
{2225, 3675 ,0.1}, { 2225, 4075 ,0.1}, { 2225, 4475 ,0.1}, { 2225, 4875 ,0.1}, { 2225, 4075 ,0.1}, {2225, 4275 ,0.1}, { 2225, 4400 ,0.1}, { 2225, 4675 ,0.1}, { 2225, 4875 ,0.1}, { 2225, 3875,0.1 },
{2325, 3675 ,0.1}, { 2325, 4075 ,0.1}, { 2325, 4475 ,0.1}, { 2325, 4875 ,0.1}, { 2325, 4075 ,0.1}, {2325, 4275 ,0.1}, { 2325, 4400 ,0.1}, { 2325, 4675 ,0.1}, { 2325, 4875 ,0.1}, { 2325, 3875,0.1 }];

   list<sensible_building> list_sensible_building;
	
   //list<point> evacuation_point <- [{500, 3000 ,0.1}, { 500, 5000 , 0.1}, {2200, 5000 , 0.1}];
   user_command "Create evacuation here" {
      create evacuation_building number: 1 with: [location::#user_location];
   }
	
	
   bool parallel <- false;
   //Shapefile for the river
   file river_shapefile <- file("../includes/RedRiver.shp");
   //Shapefile for the dykes
   file dykes_shapefile <- file("../includes/Dykes.shp");
   //Data elevation file
   file dem_file <- file("../includes/mnt50.asc");  
   //Diffusion rate
   float diffusion_rate <- 20.0;
   //Height of the dykes
   float dyke_height <- 15.0;
   //Width of the dyke
   float dyke_width <- 15.0;
    
   //Shape of the environment using the dem file
   geometry shape <- envelope(dem_file);
   
   //List of the drain and river cells
   list<cell> drain_cells;
   list<cell> river_cells;
   
   
  
   float step <- 20°mn;
   
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
      //create building number: nb_building;
      //create evacuation_building number: nb_evacuation;
	  //create sensible_building number: nb_sensible_building;
	  //create rescue_building number: nb_rescue_building;
      create citizen number: nb_citizen{
		  target <-  one_of (evacuation_building);
	  }
	  create rescuer number: nb_rescuer{
		  people_in_danger <- one_of(citizen) ; 
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
      create building number: nb_building;
      ask building parallel: parallel {
          shape <-  shape + dyke_width;
            do update_cells;
      }
      create sensible_building number: nb_sensible_building;
      ask sensible_building parallel: parallel {
          shape <-  shape + dyke_width;
            do update_cells;
      }
	  create rescue_building number: nb_rescue_building;
	  ask rescue_building parallel: parallel {
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

species building parent: obstacle parallel: parallel{
	point my_cell;
	//The building has a height randomly chosed between 2 and 10
    float height <- 2.0 + rnd(8);
    int counter_wp <- 0;
    int breaking_threshold <- 10;
      
	init {
		my_cell <- one_of(building_point);
		location <- any_location_in(my_cell);
		remove my_cell from: building_point;
	}
      
      //Action to represent the break of a building
       action break{
       	 nb_destroy_building <- nb_destroy_building + 1;
         write "building destroyed :" + nb_destroy_building;
         ask cells_concerned  {
            do update_after_destruction(myself);
         }
         do die;
      }

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

	aspect square{
		draw square(50) color: #black;
	}	
}

species evacuation_building  parent: obstacle parallel: parallel {
	//The building has a height randomly chosed between 2 and 10
    float height <- 2.0 + rnd(8);
	int breaking_threshold <- 16;
	int counter_wp <- 0;
	init {
		shape <-  shape + dyke_width;
        do update_cells;
	}
	
	//Action to represent the break of an evacuation
       action break{
       	 nb_destroy_building <- nb_destroy_building + 1;
         write "building destroyed :" + nb_destroy_building;
         ask cells_concerned  {
            do update_after_destruction(myself);
         }
         do die;
      }
  
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

	aspect square{
		draw square(70) color: #red;
	}	
}

species sensible_building parent: building {	
	bool is_sensible <- true;
	user_command define_as_target action:define_target;
	int counter_wp <- 0;
    int breaking_threshold <- 14;
	
	aspect square{
		draw square(70) color: #violet;
	}
	
	action define_target {
		ask rescuer {
			do set_target target_sb: myself;
		}
	}	
}

species rescue_building parent: building {
	int counter_wp <- 0;
    int breaking_threshold <- 14;
	aspect square{
		draw square(70) color: #green;
	}	
}	


species human skills: [moving]{
	bool is_in_water;
	evacuation_building target;
	//citizen target_people;
	building my_cell;
	float human_speed;
	int health;
	
	init {
		my_cell <- one_of(building);
		location <- my_cell.location;
		human_speed <- 0.06;
		health <- 100;
		is_in_water <- false;
	}
	
	reflex health_loss when: is_in_water = true {
		health <- health -1;
		if (health = 0) {
			nb_death <- nb_death +1;
			do die;
		}
		human_speed <- 0.01;
	}	
	
	reflex search_evacuation {
		target <- one_of(evacuation_building);
	}
}

species citizen parent: human{
	// able to evacuate depending on age : if > 70 flip(0.1)? true: false, if < 25 flip(0.7)? true: false  else true  
	// check veracity of stats  !
	bool able_to_evacuate;

	init {
		my_cell <- one_of(building);
		location <- my_cell.location;
		able_to_evacuate <- flip(0.7)? true: false;
	}
	
	//Check if the citizen is in the water
	reflex check_is_in_water {
		loop river_cell over: shuffle(river_cells){
			//Compare citizen's location with all cells in the water
			if (river_cell.cell_points.x = self.location.x and river_cell.cell_points.y = self.location.y){
				is_in_water <- true;
				break;
			}else{
				is_in_water <- false;
			}
		}
	}
	
	reflex goto when: evacuate = true and able_to_evacuate = true {
		do goto on:cell target:target speed:human_speed;
	}
	
	action leave_with_rescuer {
		do goto on:cell target:target speed:human_speed;
	}
	
	reflex leave_with_rescuer_sensitive_bulding when: evacuate_sensitive_bulding = true{	
		if(my_cell is sensible_building){
			do call_help;
		}
	}
	
	reflex check_health {
		if (health < 50) {
			do call_help;
		}
	}
	
	//citizen call the rescuer to go together in a safe place
	action call_help {
		ask rescuer {
			do do_rescue;
		}		
	}
	
	aspect circle{
		draw circle(20) color: #yellow;
	}
}

species rescuer parent: human{
	citizen people_in_danger;
	rescue_building rescue_cell;
	float speed_in_truck;
	bool target_set;
	sensible_building targeted_sb;
	list<sensible_building> sb;
	
	init {
		rescue_cell <- one_of(rescue_building);
		location <- rescue_cell.location;
		speed_in_truck <- 0.04;
		target_set <- false;
	}	

	aspect circle{
		draw circle(20) color: #red;
	}
	
	reflex go_to_target when: target_set = true{
		targeted_sb <- one_of(sb);
		do goto on:cell target:flip(prior_sensible / 100)? targeted_sb: people_in_danger speed:human_speed;
		if not dead(people_in_danger) {
			if not dead(targeted_sb) {
				// When near by building
				if (self distance_to targeted_sb < 36) {
					// Search for citizen in building
					if people_in_danger.location = targeted_sb.location {
						ask people_in_danger{
							// Ask citizen  to follow, then go in safe place
							do leave_with_rescuer;
						}	
					}
				}
			} else { // if people is alive but building is destroyed
				ask people_in_danger{
					// Ask citizen  to follow, then go in safe place
					do leave_with_rescuer;
				}	
			}
		}
	}
	
	action set_target(sensible_building target_sb){
		target_set <- true;
		list_sensible_building <+ target_sb;
		sb <- list_sensible_building;
	}
	
	action do_rescue{
		do goto on:cell target:people_in_danger speed:human_speed;
		
		// Check the distance between the rescuer and the citizen
		if (self distance_to people_in_danger < 36) {
			ask people_in_danger{
				//If the rescuer is next to the citizen, then go in safe place
				do leave_with_rescuer;
			}
		}
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
      point cell_points <- location;
      
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
         grid_value <-
         
         
         water_height + altitude;
         
         do update_is_river;
      }
      //action to compute the destruction of the obstacle
      action update_after_destruction(obstacle the_obstacle){
         remove the_obstacle from: obstacles;
         obstacle_height <- compute_highest_obstacle();
      }
      
      action get_water_height{
      	return water_height;
      }
      
      action update_is_river{
      	int val_water <- 0;
      	val_water <- max([0, min([255, int(255 * (1 - (water_height / 12.0)))])]) ;
      	
      	if (val_water < 255 ){
      		is_river <- true;
      		add self to: river_cells;
      	}else{
      		is_river <- false;
      		remove self from: river_cells;
      	}
      }
       
   }


experiment main_gui type: gui {
   	parameter "Nombre de civils" var: nb_citizen;
	parameter "Nombre de secouristes" var: nb_rescuer;
	parameter "% secouriste priorisant batiments sensibles" var: prior_sensible min:0 max:100 slider: true;
  
	user_command "Démarrer l'évacuation" {
		evacuate <- true;
	}
	user_command "Evacuer les batiments sensibles" {
		evacuate_sensitive_bulding <- true;
	}
	
   output { 
      display map type: opengl {
         	grid cell triangulation: true;
         	species dyke aspect: geometry ;
            species building aspect: square;
			species citizen aspect: circle;
			species rescuer aspect: circle;
			species rescue_building aspect: square;
			species sensible_building aspect: square;
			species evacuation_building aspect: square;
      }
   }
}