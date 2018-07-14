
% Author: Amarjit singh , Ranjit Rana, Karan seth , rokibul       % Emailid's: Amarjitdhillon@gmail.com

% ------  Router interlinking Problem by using Genetic Algorithm (GA)


function router_linking()      
    
    
    clc    % this will clear the screen 
    
    n=input('Enter the number of routers you want to install : ');
    
    router_object.graph_coordinates = rand(n,3);                       % this sets value of x and y co-ordinates 
                                                                           
    router_object.distance_matrix    = [];                             % initialize  the distance and cost matrix to null
    
    router_object.Initial_Populaton_size    = input('Please enter initial population size : ');    % this is the initial population size for GA          
         
        
    router_object.no_of_generations  = input('Please enter no. of iterations for GA to run : ');  
         
    router_object.show_progress = true;                                      % show_progress will show the GA progress if true     % ---------- true and True have different meaning as matlab is case sensitive language --------- 
    
    router_object.display_results = true;                                    % display_results  shows the GA results if  set to true
    
        
  
    %% -------------------Extract configuration starts --------------------------
    
    
    xyz_coordiantes_of_one_element     =   router_object.graph_coordinates;                  %  graph_coordinates (float) is an Nx2 matrix of city locations, where N is the number of routers
    
    distance_matrix  =   router_object.distance_matrix;              %  distance_matrix (float) is an NxN matrix of point to point distances/costs
    
    Initial_Populaton_size   = router_object.Initial_Populaton_size;         %  Initial_Populaton_size (scalar integer) is the size of the population (should be divisible by 4)
    
    no_of_generations  = router_object.no_of_generations;      %  no_of_generations (scalar integer) is the number of desired iteration_noations for the algorithm to run
    
    show_progress         = router_object.show_progress;                     %  show_progress (scalar logical) shows the GA progress if true
    
    display_results       = router_object.display_results;                   %  display_results (scalar logical) shows the GA results if true
    
       
    
    
    %%  Distance function defination
    
    if isempty(distance_matrix)
        
        no_of_routers =n; 
        a = meshgrid(1:no_of_routers) ;

  %  a=  1     2     3
   %     1     2     3
    %    1     2     3
       
        
        % a';
        
  %  a'=  1     1     1
   %      1     2     2
    %     3     3     3
    
        
          % The Euclidean distance between points p and q is the length of the line segment connecting them (\overline{\mathbf{p}\mathbf{q}}).
        distance_matrix = reshape(sqrt(sum((xyz_coordiantes_of_one_element(a,:)-xyz_coordiantes_of_one_element(a',:)).^2,2)),no_of_routers,no_of_routers);   % reshape(A,n1,n2) returns the n1 * n2 matrix, which has the same elements as A. The elements are taken column-wise from A to fill in the elements of the n1-by-n2 matrix.
    end
    
    
    
    
    %% Initialize the Population
    
    Initial_Populaton_size   = 4*ceil(Initial_Populaton_size/4);              % makes initial population size as multiple of 2
    
    init_population = zeros(Initial_Populaton_size,n);                        % generate an empty initial pop , where no of columns will decide no of router/elements
    
       
    for k = 1:Initial_Populaton_size;                                        % for all other population values the  initial population is generted randomly
         
        init_population(k,1) = 1; 
        init_population(k,n) = n;
        
       init_population(k,2:n-1) = 1+randperm(n-2)                                    %  p = randperm(n) returns a row vector containing a random permutation of the integers from 1 to n inclusive.
        
    
    end
    
    
        
    %% Run the  Simple Genetic algorithm
    % here we have initialized some parameters
    global_minima = Inf;                                                     % Inf returns the IEEE® arithmetic representation for positive infinity. 
    total_distance = zeros(1,Initial_Populaton_size);
    distance_travelled_history = zeros(1,no_of_generations);
    temprory_four_individuals = zeros(4,n);                                        % this will only store values of 4 generations
    new_population = zeros(Initial_Populaton_size,n);                       %  this will store values of all generations
    
    
    if show_progress                        %  % we can choose not to show graph by setting value of this varible to false
         figure('Name','Simple Genetic Algoithm','Numbertitle','off');      % it will show the graph of progress
        
    end
    
    
    
  %% calculate total distance from a router
      
      init_population_a = init_population;
        
    for iteration_no = 1:no_of_generations
        
        % Evaluate Each Population Member (Calculate Total Distance)
        
        for p = 1:Initial_Populaton_size                                     % this algorithm will calculate distance for every individual and then  select
            d = 0;                                                           % for every iteration_noation the value of distance is set to 0 in- order to recalsulate it
            
           % distance_matrix(init_population_a(p,k-1),init_population_a(p,k))
            for k = 2:n
                
                d = d + distance_matrix(init_population_a(p,k-1),init_population_a(p,k));
            end
            total_distance(p) = d;
        end
                       
        % Find the Best Route in the Population
        
       [minimum_distance,index] = min(total_distance);
       distance_travelled_history(iteration_no) = minimum_distance;
             
           
       
             
            
       %% ----------------------- Progress Graph for GA Starts ------------------------------------------------------ %
 if minimum_distance < global_minima;
     
            global_minima = minimum_distance;
            optimum_route = init_population_a(index,:);
            
      if show_progress
                  
            plot3(xyz_coordiantes_of_one_element(optimum_route,1),xyz_coordiantes_of_one_element(optimum_route,2),xyz_coordiantes_of_one_element(optimum_route,3),'b.-');
           
      
              
              grid on                  
                   view(10,10)    %this is view angle                
                   title(sprintf('Min Length of cable is :  = %1.2f Meters          Current Generation # %d ',minimum_distance,iteration_no));
                   xlabel('Distance in meters')
                   zlabel('Distance in meters')
                   drawnow;
                 
      end
       a = [1:n]';
       b = num2str(a);
       c = cellstr(b);
       
            text(xyz_coordiantes_of_one_element(optimum_route,1), xyz_coordiantes_of_one_element(optimum_route,2),xyz_coordiantes_of_one_element(optimum_route,3),c, 'horizontal','left', 'vertical','top');
  end
     
                      
        %%  simple Genetic Algorithm Operators
      
        
        
       size=4;
        
       disp(sprintf('              ' ));
       disp(sprintf('              ' ));
       disp(sprintf('-------- generation # %g starts  ----------' , iteration_no));
       disp(sprintf('              ' ));
       
       loop=1;
       
       selection_vector = randperm(Initial_Populaton_size) ; 
        
       for p = 4:4:Initial_Populaton_size
       tic;    
           
       disp(sprintf('-------- loop # %g starts for generation # %g   ----------' , loop,iteration_no));
       disp(sprintf('              ' ));
       
       
            loop = loop+1;
            
            init_population_a
            
            selection_vector            
            
            four_new_individuals =  init_population_a(selection_vector(p-3:p),:)
            
            Distances_for_new_individuals = total_distance(selection_vector(p-3:p))
            
            
            [min_distance_value,id_of_this] = min(Distances_for_new_individuals)
            
            Elite_individual = four_new_individuals(id_of_this,:)
            
            random_chromosomes_tobe_operated = sort(ceil(n*rand(1,2)))
            
            point_a = random_chromosomes_tobe_operated(1)
            
            point_b = random_chromosomes_tobe_operated(2)
            
            for k = 1:4 % Mutate the Best to get Three New Routes
                
                                              
                temprory_four_individuals(k,:) = Elite_individual;
                
                switch k
                    
                    case 2 % Flipping 
                       
                      disp(sprintf('              ' ));
                      disp(sprintf('              ' ));
                        disp(sprintf('Fliping Chromosome at inividual 2 between Chromosome = %g and %g for generation # %g ' , point_a,point_b,iteration_no));
                        
                         % disp(['distance = ' num2str(distance)]); 
                         
                        temprory_four_individuals(k,point_a:point_b)   = temprory_four_individuals(k,point_b:-1:point_a)
                        
                    case 3 % Swap
                        
                        disp(sprintf('              ' ));
                        disp(sprintf('              ' ));
                        disp(sprintf('Swapping Chromosome at inividual 3 between Chromosome = %g and %g for generation # %g ' , point_a,point_b,iteration_no));
                        temprory_four_individuals(k,[point_a point_b]) = temprory_four_individuals(k,[point_b point_a])
                        
                    case 4 % Slide
                        
                         disp(sprintf('              ' ));
                        disp(sprintf('              ' ));
                        disp(sprintf('Sliding Chromosome at inividual 4 between Chromosome = %g and %g for generation # %g ' , point_a,point_b,iteration_no));
                       
                        temprory_four_individuals(k,point_a:point_b)   = temprory_four_individuals(k,[point_a+1:point_b point_a])
                       
                        
                    otherwise % Do Nothing
                end
            end
            new_population(p-3:p,:) = temprory_four_individuals
        end
        
        
        
        disp(sprintf(' ***** Showing initial population ***** ' ));
        
        init_population_a
        
        disp(sprintf('             ' ));
       
        
         disp(sprintf(' **** Showing new_population **** ' ));
        
        disp(sprintf('             ' ));
       
        new_population
        
        
        init_population_a = new_population;
        
        
       ftime= toc;    % this shows time at which algorithm stops 
         
    end
               
    
    
    
    
   %%
   
   
   
   
   tic;
    
    validate = input(' Press enter to solve this problem using Modified E : ');
   
    
   init_population_b = init_population;
        
    % Run the  Simple Genetic algorithm
    % here we have initialized some parameters
    global_minima = Inf;                                                     % Inf returns the IEEE® arithmetic representation for positive infinity. 
    total_distance = zeros(1,Initial_Populaton_size);
    distance_travelled_history_b = zeros(1,no_of_generations);
    temprory_four_individuals = zeros(4,n);                                        % this will only store values of 4 generations
    new_population = zeros(Initial_Populaton_size,n);                       %  this will store values of all generations
    
    
    if show_progress                        %  % we can choose not to show graph by setting value of this varible to false
         figure('Name','Modified Genetic Algorithm','Numbertitle','off');      % it will show the graph of progress
        
    end
    
    
    
     % calculate total distance from a router
        
    for iteration_no = 1:no_of_generations
       
        % Evaluate Each Population Member (Calculate Total Distance)
        for p = 1:Initial_Populaton_size                                     % this algorithm will calculate distance for every individual and then  select
            d = 0;                                                           % for every iteration_noation the value of distance is set to 0 in- order to recalsulate it
            
           % distance_matrix(init_population_b(p,k-1),init_population_b(p,k))
            for k = 2:n
                
                d = d + distance_matrix(init_population_b(p,k-1),init_population_b(p,k));
            end
            total_distance(p) = d;
        end
                       
        % Find the Best Route in the Population
        
       [minimum_distance_b,index] = min(total_distance);
       distance_travelled_history_b(iteration_no) = minimum_distance_b;
   
        
     % ----------------------- Progress Graph for Modified GA Starts ------------------------------------------------------ %
 if minimum_distance_b < global_minima;
     
            global_minima = minimum_distance_b;
            optimum_route_b = init_population_b(index,:);
            
      if show_progress
                  
            plot3(xyz_coordiantes_of_one_element(optimum_route_b,1),xyz_coordiantes_of_one_element(optimum_route_b,2),xyz_coordiantes_of_one_element(optimum_route_b,3),'b.-');
           
      
              
              grid on                  
                   view(10,10)    %this is view angle                
                   title(sprintf('Min Length of cable is :  = %1.2f Meters          Current Generation # %d ',minimum_distance_b,iteration_no));
                   xlabel('Distance in meters')
                   zlabel('Distance in meters')
                   drawnow;
                 
      end
       a = [1:n]';
       b = num2str(a);
       c = cellstr(b);
       
            text(xyz_coordiantes_of_one_element(optimum_route_b,1), xyz_coordiantes_of_one_element(optimum_route_b,2),xyz_coordiantes_of_one_element(optimum_route_b,3),c, 'horizontal','left', 'vertical','top');
 end
 
 
 
 
 % Modified Genetic Algorithm Operators
       
 
 
       size=4;
        
       disp(sprintf('              ' ));
       disp(sprintf('              ' ));
       disp(sprintf('-------- generation # %g starts  ----------' , iteration_no));
       disp(sprintf('              ' ));
       
       loop=1;
       
       selection_vector = randperm(Initial_Populaton_size) ; 
        
       for p = 4:4:Initial_Populaton_size
            
           
       disp(sprintf('-------- loop # %g starts for generation # %g   ----------' , loop,iteration_no));
       disp(sprintf('              ' ));
       
       
            loop = loop+1;
            
            init_population_b
            
            selection_vector            
            
            four_new_individuals =  init_population_b(selection_vector(p-3:p),:)
            
            Distances_for_new_individuals = total_distance(selection_vector(p-3:p))
            
            
            [min_distance_value,id_of_this] = min(Distances_for_new_individuals)
            
            Elite_individual = four_new_individuals(id_of_this,:)
            
            random_chromosomes_tobe_operated = sort(ceil(n*rand(1,2)))
            
            point_a = random_chromosomes_tobe_operated(1)
            
            point_b = random_chromosomes_tobe_operated(2)
            
            for k = 1:4 % Mutate the Best to get Three New Routes
                
                                              
                temprory_four_individuals(k,:) = Elite_individual;
                
                switch k
                    
                    case 2 % Flipping 
                       
                      disp(sprintf('              ' ));
                      disp(sprintf('              ' ));
                        disp(sprintf('Fliping Chromosome at inividual 2 between Chromosome = %g and %g for generation # %g ' , point_a,point_b,iteration_no));
                        
                         % disp(['distance = ' num2str(distance)]); 
                         
                        temprory_four_individuals(k,point_a:point_b)   = temprory_four_individuals(k,point_b:-1:point_a)
                        
                    case 3 % Swap
                        
                        disp(sprintf('              ' ));
                        disp(sprintf('              ' ));
                        disp(sprintf('Swapping Chromosome at inividual 3 between Chromosome = %g and %g for generation # %g ' , point_a,point_b,iteration_no));
                        temprory_four_individuals(k,[point_a point_b]) = temprory_four_individuals(k,[point_b point_a])
                        
                    case 4 % Slide
                        
                         disp(sprintf('              ' ));
                        disp(sprintf('              ' ));
                        disp(sprintf('Sliding Chromosome at inividual 4 between Chromosome = %g and %g for generation # %g ' , point_a,point_b,iteration_no));
                       
                        temprory_four_individuals(k,point_a:point_b)   = temprory_four_individuals(k,[point_a+1:point_b point_a])
                       
                        
                    otherwise % Do Nothing
                end
            end
            new_population(p-3:p,:) = temprory_four_individuals
        end
        
        
        
        disp(sprintf(' ***** Showing initial population ***** ' ));
        
        init_population_b
        
        disp(sprintf('             ' ));
       
        
         disp(sprintf(' **** Showing new_population **** ' ));
        
        disp(sprintf('             ' ));
       
        new_population
        
        
        init_population_b = new_population;
        
        
    ftime1= toc;    % this shows time at which algorithm stops 
         
   
    end
    
              
         %% ----------------------- Final Graph for GA Starts  ------------------------------------------------------ %
        
        if display_results     % we can choose not to show graph by setting value of this varible to false
        
        hfig=(figure);
        set(hfig,'Position',[1 1 2000 800]);   %  set(hfig,'Position',[Positio1 Position2 length height]);
         
         
         % ----------------------- subplot(2,3,1) Starts ------------------------------------------------------ %
        
        subplot(2,3,1);
                   
         mycolor = [255 240 245] ./ 255;
         set(0,'DefaultAxesColor',mycolor);  %we have set the bg-color for  graph 
       
           
            
            plot3(xyz_coordiantes_of_one_element(:,1),xyz_coordiantes_of_one_element(:,2),xyz_coordiantes_of_one_element(:,3),'+');
            a = [1:n]';
            b = num2str(a);
            c = cellstr(b);
            text(xyz_coordiantes_of_one_element(:,1), xyz_coordiantes_of_one_element(:,2),xyz_coordiantes_of_one_element(:,3),c, 'horizontal','left', 'vertical','top');
           
        
            grid on
            view(10,10) %this is view angle
            title('Locations of each Router');     % titles has to be mentioned at end
             
             
            xlabel('Distance in meters')
            zlabel('Distance in meters')
       
        
         % ----------------------- subplot(2,3,2) Starts ------------------------------------------------------ %
        
        subplot(2,3,2);
        
            
          plot3(xyz_coordiantes_of_one_element(optimum_route,1),xyz_coordiantes_of_one_element(optimum_route,2),xyz_coordiantes_of_one_element(optimum_route,3),'b.-');
          grid on
          view(10,10) % this is view angle
            
            a = [1:n]';
            b = num2str(a);
            c = cellstr(b);
            text(xyz_coordiantes_of_one_element(optimum_route,1), xyz_coordiantes_of_one_element(optimum_route,2),xyz_coordiantes_of_one_element(optimum_route,3),c, 'horizontal','left', 'vertical','top');
            
            title(sprintf(' Min distance for packets  is = %1.2f Meters    ',minimum_distance));
            xlabel('Distance in meters')
            zlabel('Distance in meters')
                  
      
                       
          subplot
        
         % ----------------------- subplot(2,3,3) Starts ------------------------------------------------------ %
        
        subplot(2,3,3);
        
      
        area(distance_travelled_history,'LineStyle',':');
        grid on
        
        colormap prism
        
        title('Best solutions for basic Genetic Algorithm');
        xlabel('Generations')
        zlabel('Distance in meters')
        
        
        
        
        
        
     %% ----------------------- Final Graph for MGA   Starts  ------------------------------------------------------ %
        
            %----------------------- subplot(2,3,4) Starts ------------------------------------------------------ %
        
        subplot(2,3,4);
                   
         mycolor = [200 200 245] ./ 255;
         set(0,'DefaultAxesColor',mycolor);  %we have set the bg-color for  graph 
       
                      
           
                  
            
            
            plot3(xyz_coordiantes_of_one_element(:,1),xyz_coordiantes_of_one_element(:,2),xyz_coordiantes_of_one_element(:,3),'*');
            a = [1:n]';
            b = num2str(a);
            c = cellstr(b);
            text(xyz_coordiantes_of_one_element(:,1), xyz_coordiantes_of_one_element(:,2),xyz_coordiantes_of_one_element(:,3),c, 'horizontal','left', 'vertical','top');
           
        
            grid on
            view(10,10) %this is view angle
             title('Locations of each Router');     % titles has to be mentioned at end
             
             
            xlabel('Distance in meters')
            zlabel('Distance in meters')
       
        
         % ----------------------- subplot(2,3,5) Starts ------------------------------------------------------ %
        
        subplot(2,3,5);
        
            
          plot3(xyz_coordiantes_of_one_element(optimum_route_b,1),xyz_coordiantes_of_one_element(optimum_route_b,2),xyz_coordiantes_of_one_element(optimum_route_b,3),'.-');
          grid on
          view(10,10) %this is view angle
            
            a = [1:n]';
            b = num2str(a);
            c = cellstr(b);
            text(xyz_coordiantes_of_one_element(optimum_route_b,1), xyz_coordiantes_of_one_element(optimum_route_b,2),xyz_coordiantes_of_one_element(optimum_route_b,3),c, 'horizontal','left', 'vertical','top');
           
            title(sprintf(' Min length of cables  is = %1.2f Meters    ',minimum_distance_b));
            xlabel('Distance in meters')
            zlabel('Distance in meters')
                  
      
                       
          
        
         % ----------------------- subplot(2,3,6) Starts ------------------------------------------------------ %
        
        subplot(2,3,6);
        
      
        area(distance_travelled_history_b,'LineStyle',':');
        grid on
        
        colormap prism
        
        title(' Best solutions for Advance Genetic Algorithm');
        xlabel('Generations')
        zlabel('Distance in meters')
        
        %clc;
       
        end     

   



        
