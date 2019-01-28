%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Psychophysics Software Suite ( PSS )
%   
%   Test Class: provides the functionality to perform PSS test 
%  
%   Coded by: Goldberg Stanislav and Michael Lvovsky as a part of Haifa
%   University project for Dr. Karen Banai (Department of Communication
%   Disorders)
%
%   Licence: GPL
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef Test < hgsetget
    properties %(SetAccess = protected, GetAccess = protected)
        %% Parameter Options
        name; % name of a test
        filename; % name and path of test file
        create_time;
        play_time;
        blocks;
        current_block; % current
    end
    methods
        %% Constructor
        function obj=Test( name )
            obj.name=name;
            obj.blocks={}; % cell array
            obj.create_time=now();
            obj.play_time=0;
            obj.current_block=1;
            obj.filename=[];
        end
        %% play a Test step
        function play( obj )
            if obj.play_time==0
                try
                    [FileName,PathName,FilterIndex]=uiputfile('*.results','Save the Results-file');
                    obj.filename=fullfile(PathName,FileName);
                catch error
                    msgbox(error.message,'Unable to save a file','modal') ;
                end
                obj.play_time=now(); % first time - record the time
            end
            for i=1:length(obj.blocks)
                obj.current_block=i;
                fprintf('Running block %s (%g of %g)\n',obj.blocks(i).name, i, length(obj.blocks));
                semaphore=obj.blocks(i).start(0);
                waitfor(semaphore,'Name','go_on');
                close(semaphore);
            end % for
            test=obj;
            save(obj.filename, 'test' );
        end
        %% check the last Test step
        function result=check( obj, value )
            result=obj.blocks(obj.current_block).check( value);
            if  result<0 && obj.current_block+1<=length(obj.blocks)
                obj.current_block=obj.current_block+1; % checking next block
                result=check( value );
            end
        end
        %% add a block
        function result=addBlock( obj, block )
            block.setTest(obj); % set block to test
            obj.blocks=[ obj.blocks; block ];
            result=1;
        end
        %% remove a block
        function result=removeBlock( obj, number )
            
            if  length(obj.blocks)<number || number<1
                result=0;
                return;
            end
            obj.blocks(number)=[];
            result=1;
        end
        %% move a block up
        function result=up( obj, number )
            
            if  length(obj.blocks)<number || number<=1
                result=0;
                return;
            end
            block=obj.blocks(number-1);
            obj.blocks(number-1)=obj.blocks(number);
            obj.blocks(number)=block;
            result=1;
        end
        %% move a block down
        function result=down( obj, number )
            
            if  length(obj.blocks)<=number || number<1
                result=0;
                return;
            end
            block=obj.blocks(number+1);
            obj.blocks(number+1)=obj.blocks(number);
            obj.blocks(number)=block;
            result=1;
        end
        function result= save(obj )
            try
                fid = fopen(sprintf('%s.txt',obj.filename), 'wt');
            catch error
                msgbox(error.message,'Unable to save a file','modal') ;
                result=0;
                return;
            end
            %% Header test
            fprintf(fid, 'Test Name:\t%s\n', obj.name);
            fprintf(fid, 'Perform Time:\t %s\n', datestr(obj.play_time, 'HH:MM dd/mm/yyyy'));
            fprintf(fid, '\n');
            
            for block=1:length(obj.blocks)
                %% Header Block (block)
                fprintf(fid, 'Block Name:\t%s \n', obj.blocks(block).name);
                fprintf(fid, 'Step Mode:\t%s\n', obj.blocks(block).step_mode);
                fprintf(fid, 'Based On:\t%s\n', obj.blocks(block).based_on);
                fprintf(fid, 'Step On:\t%s\n', obj.blocks(block).step_on);
                value=get(obj.blocks(block).reference_sound,obj.blocks(block).step_on);
                if iscell(value) 
                    fprintf(fid, 'Reference Value:\t%d\n',value{1} );
                else
                    fprintf(fid, 'Reference Value:\t%d\n',value );
                end
                fprintf(fid, 'Start At:\t%d\n', obj.blocks(block).start_at);
                fprintf(fid, 'Stop At:\t%d\n', obj.blocks(block).stop_at);
                fprintf(fid, 'Delta:\t%d\n', obj.blocks(block).delta);
                fprintf(fid, 'Inter Stimulus Interval:\t%d\n', obj.blocks(block).ISI);
                fprintf(fid, 'Inter Trial Interval:\t%d\n', obj.blocks(block).ITI);
                fprintf(fid, 'Task:\t%s\n', obj.blocks(block).task);
                
                fprintf(fid, 'Big to Intermediate Steps:\t%d\n', obj.blocks(block).big2int);
                fprintf(fid, 'Intermediate to Small Steps:\t%d\n', obj.blocks(block).int2small);
                fprintf(fid, 'Small Steps to End:\t%d\n', obj.blocks(block).small2end);
                fprintf(fid, 'Total Trials to End:\t%d\n', obj.blocks(block).total2end);
                
                cells=obj.blocks(block).answers;
                n=length(cells);
                if n~=0
                    delta=zeros(n,1);
                    answers=zeros(n,1);
                    test_intervals=zeros(n,1);
                    response_intervals=zeros(n,1);
                    fprintf(fid, '\n');
                    fprintf(fid, 'Number\tDelta\tCorrect\tT.Int\tRes.Int\n');
                    for i=1:n
                        delta(i)=cells{i}(1);
                        answers(i)=cells{i}(2);
                        test_intervals(i)=cells{i}(3);
                        response_intervals(i)=cells{i}(4);
                        fprintf(fid, '%g\t%g\t%g\t%g\t%g\n',i,delta(i),answers(i), test_intervals(i), response_intervals(i) );
                    end
                    fprintf(fid, '\n');
                    fprintf(fid, 'Mean:\t%g\n', mean(delta));
                    fprintf(fid, 'STD:\t%g\n', std(delta));
                    fprintf(fid, '\n');
                end
            end
            fclose(fid);
            result=1;
        end
    end %methods
end % class