/**
* Name: simulation
* Author: caporali & artru
* Description: 
* Adaptation d'un model de crue fournit avec un modèle d'évacutation créé  par alice & estelle 
* Pour ajouter notre modèle à un autre, nous utilisons le concept de comodel.
*/ 


model simulation

/** Inspired by the model :
*
* Name: Comodel of Flood and Evacuation model
* Author: HUYNH Quang Nghi
* Description: Co-model example : couple the evacuation model with the flood model. Water win or human win?
* Tags: comodel
 */
 
import "simulateurCrue.gaml" as Evacuation 
import "Flood Adapter.gaml" as Flooding	

global
{
	//set the bound of environment
	geometry shape <- envelope(file("../includes/mnt50.asc"));
	geometry the_free_shape<-copy(shape);
	//counting variable of casualty
	int casualty <- 0;
	
	list<point> offset <- [{ 50, 1700 }, { 800, 3400 }, { 2900, 0 }, { 4200, 2900 }, { 5100, 1300 }];
	list<point> exits <- [{250, 1600 }, { 400, 4400 }, { 4100, 1900 }, { 6100, 2900 }, { 5700, 900 }];
	
	init
	{
		//create experiment from micro-model myFlood with corresponding parameters
		//create Flooding."Adapter";
	
		//create the Evacuation micro-model's experiment
		create Evacuation."evacuation" number:length(offset)
		{
			//centroid <- myself.offset[int(self)];
			//target_point <- myself.exits[int(self)];
			//transform the environment and the agents to new location (near the river)
			do transform_environment;
			loop t over: list(building)
			{
				myself.the_free_shape <- myself.the_free_shape - (t.shape + 10);
			}
			
			// free_space<-copy(myself.the_free_shape);			
			// free_space <- free_space simplification(1.0);
		}

	}

	reflex doing_cosimulation
	{
		//do a step of Flooding
		ask Flooding."Adapter" collect each.simulation
		{
			do _step_;
		}

		//people evacate 
		ask Evacuation."evacuation" collect each.simulation
		{
			//depending on the real plan of evacuation, we can test the speed of the evacuation with the speed of flooding by doing more or less simulation step 
				do _step_;
		}
		

	}

}

experiment simple type: gui
{
	output
	{
		display "Comodel Display"  type:opengl
		{
			agents "batiment" value: Evacuation."evacuation"  accumulate each.get_batiment();
			agents "civil" value:  Evacuation."evacuation"  accumulate each.get_civil();
			graphics "exits" refresh:false{
				loop e over: exits
				{
					draw sphere(100) at: e color: # green;
				}

			}
			agents "cell" value: first(Flooding."Adapter").get_cell();
			agents "dyke" value: first(Flooding."Adapter").get_dyke() aspect: geometry ;
		}

	}

}