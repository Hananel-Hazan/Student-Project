%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Psychophysics Software Suite ( PSS )
%   
%   GapSound Class: used to generate gap separated sound 
%  
%   Coded by: Goldberg Stanislav and Michael Lvovsky as a part of Haifa
%   University project for Dr. Karen Banai (Department of Communication
%   Disorders)
%
%   Licence: GPL
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef GapSound < Sound
    methods
        function obj=GapSound( sound1, sound2 , gap )
            obj=obj@Sound( sound1.duration+sound2.duration+gap, sound1.intensity );
            obj.sound1=sound1.clone();
            obj.sound2=sound2.clone();
            obj.gap=gap;
        end
        %% Copy Constructor
        function other=clone( obj )
            other=GapSound( obj.sound1.clone(), obj.sound2.clone() , obj.gap );
        end
        %% Play the Sound
        function play( obj )
            fprintf( 'The GapSound with %1.2g sec gap is playing\n', obj.gap/1000);
            obj.play_now();
        end
        %% Generate the Sound data
        function data=generate( obj  )
            n=obj.gap/1000*obj.sample_frequency;
            data=[ obj.sound1.generate() , zeros(1,n) ,  obj.sound2.generate() ];
        end
    end
    methods(Static)
        %% Get the Sound Type
        function type=getType( )
            type='Gap Sound';
        end
    end
    properties %(SetAccess = protected, GetAccess = protected)
        gap;
    end
    properties %(SetAccess = protected, GetAccess = protected)
        sound1;
        sound2;
    end
end