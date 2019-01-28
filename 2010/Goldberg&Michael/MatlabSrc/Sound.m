%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Psychophysics Software Suite ( PSS )
%   
%   Sound Class: provides the functionality of abstract Sound class used as
%   a template for other sounds
%  
%   Coded by: Goldberg Stanislav and Michael Lvovsky as a part of Haifa
%   University project for Dr. Karen Banai (Department of Communication
%   Disorders)
%
%   Licence: GPL
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef Sound < hgsetget
    methods (Abstract)
        play( obj );
        data=generate( obj );
        type=getType( obj );
        other=clone(obj);
    end
    methods
        function obj=Sound( duration, intensity)
            obj.duration=duration;
            obj.intensity=intensity;
            obj.sample_frequency=44000;
            obj.bits=16;
            fade_time=obj.sample_frequency*0.02; % fading time in sec
            obj.fade_in=linspace(-pi/2,0,fade_time);
            obj.fade_in=cos(obj.fade_in);
            obj.fade_in=(obj.fade_in).^2;
            obj.fade_out=obj.fade_in(end:-1:1);
        end
        function play_now( obj )
           data=obj.generate( );
           if length(data) - 2*length(obj.fade_in) > 0
               pad=ones(1, length(data) - 2*length(obj.fade_in));
               ramp=[obj.fade_in,pad,obj.fade_out];
               data=data.*ramp;
           end
           sound(data,obj.sample_frequency,obj.bits );
           pause(obj.duration/1000);
       end 
    end
    properties %(SetAccess = protected, GetAccess = protected)
        duration;
        intensity;
    end
    properties (SetAccess = protected, GetAccess = protected)
        sample_frequency; % sample freq for Sound generation
        bits; % number of bits for Sound generation
        fade_in;
        fade_out;
    end
end
