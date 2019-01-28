%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Psychophysics Software Suite ( PSS )
%   
%   NoiseSound Class: used to generate a noise based sound 
%  
%   Coded by: Goldberg Stanislav and Michael Lvovsky as a part of Haifa
%   University project for Dr. Karen Banai (Department of Communication
%   Disorders)
%
%   Licence: GPL
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef NoiseSound < Sound
   methods
       function obj=NoiseSound( duration, intensity , start_freq, stop_freq )
           obj=obj@Sound(duration, intensity );
           obj.start_frequency=start_freq;
           obj.stop_frequency=stop_freq;
       end
       %% Copy Constructor
       function other=clone( obj )
         other=NoiseSound( 0, 0 , 0, 0 );
         props = properties(obj);
         for i = 1:length(props)
            eval(['other.' props{i} ' = obj.' props{i} ';']);
         end
       end
       %% Play the Sound 
       function play( obj )
           fprintf( 'The NoiseSound with freqs=[%g,%g] is playing\n', obj.start_frequency, obj.stop_frequency );
           obj.play_now();
       end 
       %% Generate Sound data
       function data=generate( obj )
           data=randn(1,obj.sample_frequency).*( obj.duration/1000); % 1000 cause duration is in [ms]
           if  ~(obj.start_frequency==0 && obj.stop_frequency==0 ) % no band filtering
               n=length(data);
               fft_data=fft(data);
               fft_shifted = fftshift(fft_data); 
               freq = (-n/2:n/2-1)*(obj.sample_frequency/n);
               fft_shifted_filtered=fft_shifted.*( abs(freq)>=obj.start_frequency & abs(freq)<=obj.stop_frequency );
               fft_filtered=fftshift(fft_shifted_filtered);
               data=ifft(fft_filtered);
           end
            data=data./max([max(data),-min(data)]).*obj.intensity; % normalize
       end
   end
   methods(Static)
       function type=getType( )
           type='Noise Sound';
       end
  end
   properties %(SetAccess = protected, GetAccess = protected)
      start_frequency; 
      stop_frequency;
   end
end