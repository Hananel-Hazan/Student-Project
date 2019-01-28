%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Psychophysics Software Suite ( PSS )
%   
%   PureSound Class: provides the functionality of one tone sound
%  
%   Coded by: Goldberg Stanislav and Michael Lvovsky as a part of Haifa
%   University project for Dr. Karen Banai (Department of Communication
%   Disorders)
%
%   Licence: GPL
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef PureSound < Sound
   methods
       function obj=PureSound( duration, intensity , frequency )
           obj=obj@Sound(duration, intensity );
           obj.frequency=frequency;
       end
       %% Copy Constructor
       function other=clone( obj )
         other=PureSound(0,0,0);
         props = properties(obj);
         for i = 1:length(props)
            eval(['other.' props{i} ' = obj.' props{i} ';']);
         end
       end
       %% Play the Sound
       function play( obj )
           fprintf( 'The PureSound with freq=%g is playing\n',obj.frequency );
           obj.play_now();
       end 
       %% Generate Sound data
       function data=generate(obj )
           data=1:obj.sample_frequency* ( obj.duration/1000); % 1000 cause duration is in [ms]
           data=sin(data.*(2*pi*obj.frequency/obj.sample_frequency)).*obj.intensity;
       end 
   end
   %% Get the Sound type
   methods(Static)
       function type=getType( )
           type='Pure Sound';
       end
  end
   properties %(SetAccess = protected, GetAccess = protected)
      frequency; 
   end
end