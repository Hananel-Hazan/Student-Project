%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Psychophysics Software Suite ( PSS )
%   
%   Block Class: provides the functionality of PSS test blocks
%  
%   Coded by: Goldberg Stanislav and Michael Lvovsky as a part of Haifa
%   University project for Dr. Karen Banai (Department of Communication
%   Disorders)
%
%   Licence: GPL
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef Block < hgsetget
    properties %(SetAccess = protected, GetAccess = protected)
        %% Parameter Options
        test; % test the Block belongs to
        name; % name of the Block
        theme;  % theme of the Block
        reference_sound; % sound to be played as reference
        step_mode; % { additive, multiplicative }
        based_on; % { reversals, trials }
        start_at; % start Block with with parameter
        stop_at; % stop changing parameter if exceed this value
        % other_stimulus; % { lower, higher }  no need since start_at shows the direction
        step_on; % parameter to change in reference sound
        delta; % amount for a parameter's change
        %% Inter Stimulus Interval = ISI
        ISI; % Inter Stimulus Interval can be in modes {fixed, random}
        ITI; % Inter Trials Interval
        %% Task
        task; % could be in  AXB, XXA form , where X - reference sound, A or B - changed sound ( selected random )
        %% Steps
        big_step; % percent of delta for big steps
        int_step; % percent of delta for intermediate steps
        small_step; % percent of delta for small steps
        %% Thresholds
        big2int; % number of events to switch from big steps mode to intermediate
        int2small; % number of events to switch from int. steps mode to small
        small2end; % number of events to switch from small steps mode to finish of the Block
        total2end; % number of total trials to finish
    end
    properties %(SetAccess = protected, GetAccess = protected)
        %% Current Block properties
        GUI; % Java GUI
        current_delta;
        current_value; % current value of other stimulus
        current_mode; % { big, int, small }
        current_mode_steps; % steps in  current_mode
        total_steps;% total steps
        correct_answer; % id of the last correct answer
        correct_answers; % number of correct answers before change
        wrong_answers; % number of wrong answers before change
        current_direction;
        last_direction; % stores if the last direction was asc (1) or desc (-1)
        answers; % cell array for Block answers
        semaphore; % figure obj used as semaphore
    end
    methods
        %% Constructor
        function obj=Block( name, theme, sound, step_mode, based_on, start_at, stop_at, step_on, delta,  ISI, task, big_step, int_step, small_step, big2int, int2small,  small2end, total2end )
            obj.GUI=0;
            obj.semaphore=0;
            obj.theme=theme;
            obj.name=name;
            obj.reference_sound=sound;
            obj.delta=delta;
            obj.ISI=ISI;
            obj.ITI=1000; % hard coded
            obj.task=task;
            obj.step_on=step_on;
            obj.step_mode=step_mode;
            obj.based_on=based_on;
            obj.start_at=start_at;
            obj.stop_at=stop_at;
            obj.big_step=big_step/100; % if given in percent
            obj.int_step= int_step/100;
            obj.small_step=small_step/100;
            obj.big2int=big2int;
            obj.int2small=int2small;
            obj.small2end=small2end;
            obj.total2end=total2end;
            %%
            obj.current_delta=obj.delta*obj.big_step; % starting with big delta
            value=get(obj.reference_sound,obj.step_on);
            if iscell(value)
                value=value{1};
            end
            obj.current_value=obj.start_at - value;
            obj.current_mode='big';
            obj.current_mode_steps=0;
            obj.total_steps=0;
            obj.correct_answer=0;
            obj.correct_answers=3; % number of  correct answers' verification
            obj.wrong_answers=1; % 1 - no verification
            obj.last_direction=0;  % no last directon value during initialization
            obj.current_direction=0; 
            obj.answers={};
        end
        %% Play the stimuli
        function result=play( obj )
            if obj.total_steps==0 % initialization of random parameters
                if length(obj.ISI)>1
                    obj.ISI=round( abs(obj.ISI(2) - obj.ISI(1)) )*rand + obj.ISI(1) ; % putting random value in ISI
                end 
            end
            if obj.total_steps>=obj.total2end % stop the steps
                fprintf('The End: Total Trials %g are finished\n',obj.total_steps);
                result=0;
                obj.stop(1);
                return;
            else
                result=-1; % 'Something is wrong?';
            end
            %% Big step mode
            if strcmp(obj.current_mode, 'big' ) % big step mode
                if  obj.current_mode_steps>=obj.big2int  % switch from big to int
                    fprintf('Finished %g Big steps. Switching from Big steps to Intermediate\n',obj.current_mode_steps);
                    obj.current_mode='int';
                    obj.current_delta=obj.delta*(obj.int_step);
                    obj.current_mode_steps=0;
                end
                obj.current_delta=obj.delta*obj.big_step;
            end % if big
            %% Intermediate step mode
            if strcmp(obj.current_mode, 'int' ) % int step mode
                if  obj.current_mode_steps>=obj.int2small  % switch from int to small
                    fprintf('Finished %g Intermediate steps. Switched from Intermediate steps to Small\n',obj.current_mode_steps);
                    obj.current_mode='small';
                    obj.current_delta=obj.delta*(obj.small_step);
                    obj.current_mode_steps=0;
                end
                obj.current_delta=obj.delta*obj.int_step;
            end % if int
            %% Small step mode
            if strcmp(obj.current_mode, 'small' ) % small step mode
                if  obj.current_mode_steps>=obj.small2end  % switch from small to end
                    obj.current_mode='end';
                    result=0;
                    fprintf('Finished %g Small steps. Switched from Small steps to End\n',obj.current_mode_steps);
                    obj.stop(1);
                    return;
                end
                obj.current_delta=obj.delta*obj.small_step;
            end % if small
            %% Changing the sound
            value=get(obj.reference_sound,obj.step_on) ;
            sound=obj.reference_sound.clone();
            if iscell(value)
                value{1}=value{1}+obj.current_value;
                set(sound,obj.step_on,value);
                fprintf('Changed %s from %g to %g \n',obj.step_on,value{1},value{1}+obj.current_value);
            else
            set(sound,obj.step_on,value+obj.current_value); % other stimuli
            fprintf('Changed %s from %g to %g \n',obj.step_on,value,value+obj.current_value);
            end
            %% Parsing the task & playing the sound
            n=length(obj.task);
            if  length(regexpi(obj.task,'x|a|b'))~=n || n<2  ||  length(regexpi(obj.task,'a'))~=1 ||  length(regexpi(obj.task,'b'))~=1
                % if task is not well formed
                error('%s is not well formed task',obj.task);
                return;
            end
            a_reference=rand(1)>=0.5;
            for i=1:n
                switch obj.task(i)
                    case {'a','A'}
                        if a_reference
                            obj.GUI.animateSound(i,sound.duration);
                            obj.reference_sound.play();
                        else
                            obj.GUI.animateSound(i,sound.duration);
                            sound.play();
                            obj.correct_answer=regexpi(obj.task,'a');
                            result=i;
                        end
                    case {'b','B'}
                        if ~a_reference
                            obj.GUI.animateSound(i,obj.reference_sound.duration);
                            obj.reference_sound.play();
                        else
                            obj.GUI.animateSound(i,sound.duration);
                            sound.play();
                            obj.correct_answer=regexpi(obj.task,'b');
                            result=i;
                        end
                    case {'x','X'}
                        obj.GUI.animateSound(i,obj.reference_sound.duration);
                        obj.reference_sound.play();
                end
                pause( obj.ISI/1000 ); % wait , ISI in ms is converted to sec
            end
        end
        %% Check the answer & change the current_value
        function result=check( obj, answer )
            % obj.disableGUI();
            obj.total_steps = obj.total_steps+1;
            result=(answer==obj.correct_answer);
            obj.answers{obj.total_steps}=[obj.current_value,result,obj.correct_answer,answer];
            if obj.total_steps> obj.total2end || strcmp(obj.current_mode,'end') % stop the steps
                result=-1;
                return;
            end
            old_current_value=obj.current_value;
            %% Correct answer - the  change
            if result==1
                if obj.correct_answers<=1
                    obj.correct_answers=3;
                else
                    obj.correct_answers=obj.correct_answers -1;
                    return;
                end
                % Performing the change
                obj.current_direction=1; % asc direction;
                if strcmp( obj.step_mode, 'additive' )
                    %% additive mode
                    if obj.current_value>0
                        obj.current_value=obj.current_value - obj.current_delta ;
                    else % obj.current_value<=0
                        obj.current_value=obj.current_value + obj.current_delta ;
                    end
                end
                if strcmp( obj.step_mode, 'mulplicative' )
                    %% multiplicative mode
                    obj.current_value=obj.current_value / obj.current_delta ;
                end
            else
                %% Incorrect answer - the change
                obj.correct_answers=3;
                if obj.wrong_answers<=1
                    obj.wrong_answers=1;  
                else
                    obj.wrong_answers=obj.wrong_answers -1;
                    return;
                end
                % Performing the change
                obj.current_direction=-1; % desc direction
                if strcmp( obj.step_mode, 'additive' )
                    %% additive mode
                    if obj.current_value>0
                        obj.current_value=obj.current_value + obj.current_delta ;
                    else % obj.current_value<=0
                        obj.current_value=obj.current_value - obj.current_delta ;
                    end
                end
                if strcmp( obj.step_mode, 'mulplicative' )
                    %% multiplicative mode
                    obj.current_value=obj.current_value* obj.current_delta ;
                end
            end
            
            if strcmp(obj.based_on,'trials')
                %% Trials based
                % increasing steps counters
                obj.current_mode_steps = obj.current_mode_steps+1;
            end
            if strcmp(obj.based_on,'reversals')
                %% Reverses based
                if obj.last_direction~=0 && obj.current_direction~=obj.last_direction % skipping first step with 0
                    % reversal detected - increasing steps counters
                    obj.current_mode_steps = obj.current_mode_steps+1; % 
                end
                obj.last_direction=obj.current_direction;
            end
            
            value=get(obj.reference_sound,obj.step_on) ;
            if iscell(value)
                value=value{1};
            end
            
            if  sign(  obj.current_value) ~= sign( obj.start_at - value  ) % crossed zero - restoring value
                obj.current_value=old_current_value;
            end
            if ( obj.stop_at~=0 ) && ( abs(obj.current_value) >=abs( obj.stop_at - value)  ) % stop_at value exceeded - restoring value
                obj.current_value=old_current_value;
            end
            
        end
        %% Next function
        function result=next(obj, varargin )
            if length(varargin)==1
                answer=varargin{1};
            else
                answer=varargin{3};
            end
            fprintf('check(%g)\n',answer);
            result=obj.check(answer);
            if result ==1 % correct answer
                obj.GUI.animateHappy(obj.correct_answer,2000);
                obj.GUI.animateHappyFace(2000);
                pause(2);
            end
            if result ==0 % wrong answer
                obj.GUI.animateCry(obj.correct_answer,1000);
                pause(1);
            end
            pause(0.5); % ITI ?
            if obj.total_steps> obj.total2end || strcmp(obj.current_mode,'end')  % end of Block
                obj.stop(1); % end the Block
                return;
            end
            obj.GUI.moveNextStep();
            pause(0.5); % get user focus
            obj.save(); % save the intermediate results
     
            obj.play();
        end
        %% Start the Block
        function semaphore=start( obj, varargin )
            if length(varargin)==1
                value=varargin{1};
            else
                value=varargin{3};
            end
            if  obj.GUI==0
                warning off
                try
                    filepath=which('tools');
                    path=fileparts(filepath);
                    javapath=fullfile(path,'BlockGUI.jar');
                    javaaddpath(javapath); %GUI initialization
                catch e
                    disp( e.message );
                end
                obj.GUI=javaObject('MainFrame',obj.task,obj.total2end,obj.theme'');
                warning on
            end
            if obj.semaphore==0
                semaphore=figure('Visible','off');
                obj.semaphore=semaphore;
            end
            if value==0
                hStart = handle(obj.GUI.signPnl,'callbackProperties');  % setting callbacks
                obj.GUI.changeToStartSign();
                set(hStart,'MousePressedCallback',{@obj.start,1});
                GUI_handle = handle(obj.GUI,'callbackProperties');
                set(GUI_handle,'WindowClosedCallback',{@obj.stop,1});
            end
            if value==1
                obj.enableGUI();
                obj.GUI.changeToStopSign();
                hStop = handle(obj.GUI.signPnl,'callbackProperties');  % setting callbacks
                set(hStop,'MousePressedCallback',{@obj.stop,0});
                obj.play();
            end
        end
        function enableGUI(obj)
            if obj.GUI~=0
                for i = 1:length(obj.task);
                    if ~(obj.task(i)=='x' || obj.task(i)=='X') % ignoring x case trials
                        hPanel = handle(obj.GUI.motionPnl(i),'callbackProperties');  % setting callbacks
                        set(hPanel,'MousePressedCallback',{@obj.next,i});
                    end
                end
            end
        end
        function disableGUI(obj)
            if obj.GUI~=0
                for i = 1:length(obj.task);
                    hPanel = handle(obj.GUI.motionPnl(i),'callbackProperties');  % disabling callbacks
                    set(hPanel,'MousePressedCallback',{});
                end
            end
        end
        %% Stop the Block
        function stop( obj, varargin  )
            if length(varargin)==1
                value=varargin{1};
            else
                value=varargin{3};
            end
            if value==0 % pause - disabling callbacks
                obj.disableGUI();
                hStart = handle(obj.GUI.signPnl,'callbackProperties');  % setting callbacks
                set(hStart,'MousePressedCallback',{@obj.start,1});
                obj.GUI.changeToStartSign();
            else
                fprintf('The block %s is over\n',obj.name);
                obj.GUI.setVisible(0); % actual stop
                obj.GUI=0; % destroying the GUI
                set(obj.semaphore,'Name','go_on'); % turning on the semaphore
            end
        end
        %% Assign the test to Block
        function setTest( obj, test )
            set(obj,'test',test);
        end
         %% Saves all test to file 
        function result=save( obj )
            result=obj.test.save();
        end
        %% Get the value to change
        function result=get_reference( sound, property )
            result=0;
            if strcmp( property, 'duration' )
                result=sound.duration;
            end
            if strcmp( property, 'intensity' )
                result=sound ;
            end
            if strcmp( property, 'frequency' )  &&  ( ~strcmp( sound.getType(), 'NoiseSound' ) || ~strcmp( sound.getType(), 'GapSound' ) )
                result=sound.frequency;
            end
            if strcmp( property, 'mod_frequency' )  &&  ( strcmp( sound.getType(), 'ModulatedSound' ) )
                result=sound.mod_frequency ;
            end
            if strcmp( property, 'mod_depth' )  &&  ( strcmp( sound.getType(), 'ModulatedSound' ) )
                result=sound.mod_depth;
            end
            if strcmp( property, 'gap' )  &&  ( strcmp( sound.getType(), 'GapSound' ) )
                result=sound.mod_depth;
            end
            if strcmp( property, 'start_frequency' )  &&  ( strcmp( sound.getType(), 'NoiseSound' ) )
                result=sound.start_frequency;
            end
            if strcmp( property, 'stop_frequency' )  &&  ( strcmp( sound.getType(), 'NoiseSound' ) )
                result=sound.stop_frequency;
            end
        end
        %% Get the sound after change
        function sound=get_sound( obj, property, value)
            sound=obj.reference_sound;
            if strcmp( property, 'duration' )
                sound.duration=value;
            end
            if strcmp( property, 'intensity' )
                sound.intensity=value;
            end
            if strcmp( property, 'frequency' )  &&  ( ~strcmp( sound.getType(), 'NoiseSound' ) || ~strcmp( sound.getType(), 'GapSound' ) )
                sound.frequency=value;
            end
            if strcmp( property, 'mod_frequency' )  &&  ( strcmp( sound.getType(), 'ModulatedSound' ) )
                sound.mod_frequency=value;
            end
            if strcmp( property, 'mod_depth' )  &&  ( strcmp( sound.getType(), 'ModulatedSound' ) )
                sound.mod_depth=value;
            end
            if strcmp( property, 'gap' )  &&  ( strcmp( sound.getType(), 'GapSound' ) )
                sound.mod_depth=value;
            end
            if strcmp( property, 'start_frequency' )  &&  ( strcmp( sound.getType(), 'NoiseSound' ) )
                sound.start_frequency=value;
            end
            if strcmp( property, 'stop_frequency' )  &&  ( strcmp( sound.getType(), 'NoiseSound' ) )
                sound.stop_frequency=value;
            end
        end
    end
end