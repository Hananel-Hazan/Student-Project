%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Psychophysics Software Suite ( PSS )
%   
%   AccordSound Class: provides the functionality of accord based sound
%   generation
%  
%   Coded by: Goldberg Stanislav and Michael Lvovsky as a part of Haifa
%   University project for Dr. Karen Banai (Department of Communication
%   Disorders)
%
%   Licence: GPL
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef AccordSound < Sound 
   methods
       function obj=AccordSound( duration, intensity , varargin )
           obj=obj@Sound( duration, intensity );
           if length (varargin) < 1
               error('Not enough input arguments'); 
           end
           obj.frequencies=varargin(1);
           for i=2:length(varargin)
               obj.frequencies=[ obj.frequencies ,varargin{i} ];
           end
        end
        %% Copy Constructor
       function other=clone( obj )
         other=AccordSound(0,0,0,0);
         props = properties(obj);
         for i = 1:length(props)
            eval(['other.' props{i} ' = obj.' props{i} ';']);
         end
       end
       %% Play the Sound
       function play( obj )
           fprintf( 'The AccordSound  with number of frequencies=%g is playing\n', length(obj.frequencies) );
           obj.play_now();
       end
       %% Generate the Sound
       function data=generate(obj )
           n=obj.sample_frequency * ( obj.duration/1000);
           data=zeros(1,n);
           for i=1:length(obj.frequencies)
               d=1:n; % 1000 cause duration is in [ms]
               d=sin(d.*(2*pi*obj.frequencies{i}/obj.sample_frequency));
               data=data+d;
           end
           data=data./max([max(data),-min(data)]).*obj.intensity; % normalize
       end 
   end
   methods(Static)
       %% Get the Sound Type
       function type=getType( )
           type='Accord Sound';
       end
  end
   properties %(SetAccess = protected, GetAccess = protected)
      frequencies; 
   end
end