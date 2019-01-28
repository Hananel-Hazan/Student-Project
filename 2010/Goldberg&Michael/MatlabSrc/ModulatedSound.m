%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Psychophysics Software Suite ( PSS )
%   
%   ModulatedSound Class: used to generate  amplitude or frequency modulated sound 
%  
%   Coded by: Goldberg Stanislav and Michael Lvovsky as a part of Haifa
%   University project for Dr. Karen Banai (Department of Communication
%   Disorders)
%
%   Licence: GPL
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef ModulatedSound < Sound
   methods
       function obj=ModulatedSound( sound, mod_frequency, mod_depth, mod_type )
           obj=obj@Sound( sound.duration, sound.intensity );         
           obj.mod_frequency=mod_frequency;
           obj.mod_depth=mod_depth;
           obj.mod_type=mod_type;
           obj.sound=sound;
       end
       %% Copy Constructor
       function other=clone( obj )
         other=ModulatedSound( obj.sound, 0, 0, 0 );
         props = properties(obj);
         for i = 1:length(props)
            eval(['other.' props{i} ' = obj.' props{i} ';']);
         end
       end
       %% Play the Sound
       function play( obj )
           fprintf( 'The ModulatedSound  with mod. frequency=%d,  mod. depth=%d is playing\n', obj.mod_frequency, obj.mod_depth );
           obj.play_now();
       end
       %% Generate the Sound data
       function data=generate( obj )
           n=obj.duration/1000*obj.sample_frequency;
           carrier_data=obj.sound.generate();
           mod_data=(1:n)./obj.sample_frequency;
           if strcmp(obj.mod_type,'am') || strcmp(obj.mod_type,'AM') % amplitude modulation
               %disp('am');           
               mod_data=1+obj.mod_depth*sin( 2 * pi * obj.mod_frequency * mod_data);
               data=mod_data.*carrier_data;
           else % mod_type=='fm' % frequency modulation
               %disp('fm');
               mod_data=obj.mod_depth * cos( 2 * pi * obj.mod_frequency * mod_data );
               data=sin( carrier_data + mod_data);
           end
            data=data./max([max(data),-min(data)]); % normalize
       end
   end
   methods(Static)
       %% Get the Sound type
       function type=getType( )
           type='Modulated Sound';
       end
   end
   properties %(SetAccess = protected, GetAccess = protected)
       mod_frequency;
       mod_depth;
       mod_type;
   end
   properties %(SetAccess = protected, GetAccess = protected)
       sound;
   end

end