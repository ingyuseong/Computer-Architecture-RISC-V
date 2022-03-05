//#include "problem1.h"
//#include <stdlib.h>

#define START 0
#define NUM_VERTEX 10
#define LIMIT 12
//#define DEBUG 
int color [NUM_VERTEX];
int adj_graph  [NUM_VERTEX][NUM_VERTEX];
int queue[LIMIT]; // Array implementation of queue
int front, rear; // To insert and delete the data elements in the queue respectively
int i, j; // To traverse the loop to while displaying the stack

char vertex_name(int offset){
	const int base = 65;
	return (base+offset);
}

void dfs(){
	int i;
	for(i = 0; i < NUM_VERTEX; i++)
		color[i] = 0;//White
	dfs_search(START);
	  for(i = 0; i < NUM_VERTEX; i++){
		if(color[i] == 0){//white
			dfs_search(i);
		}
	}
}

void dfs_search(int start){
	color[start] = 1;//gray
	int i;
	for(i = 0; i < NUM_VERTEX; i++){
		if(adj_graph[start][i] && color[i] == 0){
			dfs_search(i);
		}
	}
	color[start] = 2;
}
void bfs(){
	int i;
	for(i = 0; i < NUM_VERTEX; i++)
		color[i] = 0;//White

	bfs_search(START);
	for(i = 0; i < NUM_VERTEX; i++){
		if(color[i] == 0){
			bfs_search(i);
		}
	}
}

void bfs_search(int start){
	int source,sink;
	int i;
	//init();
	insert(start);
	color[start] = 1;	
	//while(Queue->count!=0){
	while((front == -1) && (rear == -1)){
		source = queue[rear];
		for(i = 0; i < NUM_VERTEX; i++){
			if(adj_graph[source][i] && color[i] == 0){
				color[i] = 1;
				insert(i);
			}
			color[source] = 2;
		}
	}
}

void insert(int input)
{
	int element;
	if (rear == LIMIT - 1) return;
	else {
	  if (front == - 1)
	  {
		  front = 0;
	      element = input;
	      rear++;
	      queue[rear] = element;
	  }
    }
}
void delet(int input)
{
  if (front == - 1 || front > rear) return;
  else{
   front++;
  }
}

int main()
{
  front = -1;
  rear = -1;

  for(i = 0; i < NUM_VERTEX; i++){
		for(j = 0; j < NUM_VERTEX; j++){
			adj_graph[i][j] = 0;
		}
  }

  int div_val, q_val;
  div_val= 3;
  q_val= 3;
  
  	adj_graph[0][1] = div_val/q_val;
    //adj_graph[0][2] = 1;
    //adj_graph[0][8] = 1;
    adj_graph[0][9] = div_val/q_val;
    
    adj_graph[1][2] = div_val/q_val;
    adj_graph[1][3] = div_val/q_val;
    
    // adj_graph[2][3] = div_val/q_val;
    // adj_graph[2][4] = div_val/q_val;    
    
    adj_graph[3][5] = 1;
    adj_graph[3][4] = 1;    

    adj_graph[4][6] = 1;
    adj_graph[4][5] = 1;

    adj_graph[5][6] = 1;
    adj_graph[5][7] = 1;

    adj_graph[6][2] = 1;
    adj_graph[6][3] = 1;

    adj_graph[7][5] = 1;
    adj_graph[7][9] = 1;

    adj_graph[8][7] = 1;
    adj_graph[8][1] = 1;

    adj_graph[9][4] = 1;
    adj_graph[9][3] = 1;
  // for(i = 0; i < 3; i++){
	// 	for(j = 0; j < 4; j++){
	// 		adj_graph[i][j] = 0;
	// 	}
  // }

    dfs();
    // printf("BSF\n");
    // bfs();
}