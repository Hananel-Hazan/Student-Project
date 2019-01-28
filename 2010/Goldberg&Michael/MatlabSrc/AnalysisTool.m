%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Psychophysics Software Suite ( PSS )
%   
%   AnalysisTool: enable the user to see PSS test results and to perform a
%   basic data processing ( mean, standard deviation) for selected trials
%  
%   Coded by: Goldberg Stanislav and Michael Lvovsky as a part of Haifa
%   University project for Dr. Karen Banai (Department of Communication
%   Disorders)
%
%   Licence: GPL
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function AnalysisTool(  )
try
    [FileName,PathName,FilterIndex]=uigetfile('*.results','Load the Results-file');
    filename=fullfile(PathName,FileName);
catch error
    msgbox(error.message,'Unable to load a file','modal') ;
    return;
end
mat=load( filename,'-mat' );
test=mat.test;

for block=1:length(test.blocks)
    figure;     
    cells=test.blocks(block).answers;
    n=length(cells);
    delta=zeros(n,1);
    answers=zeros(n,1);
    test_intervals=zeros(n,1);
    response_intervals=zeros(n,1);
    x=1:n;
        for i=1:n
        delta(i)=cells{i}(1);
        answers(i)=cells{i}(2);
        test_intervals(i)=cells{i}(3);
        response_intervals(i)=cells{i}(4);
        end

    plot(x,delta,'--ks','LineWidth',2,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','w',...
        'MarkerSize',10);
    hold on
    plot(x(answers==1),delta(answers==1),'ks','LineWidth',2,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','k',...
        'MarkerSize',10);
    % plot(x, zeros(n,1),'-k');
    hold off
    set(gca,'XTick',1:n) % This automatically sets the XTickMode to manual.
    %                     set(gca,'XTickLabel',delta)
    %                     set(gca,'YTick',[0;1]) % This automatically sets the XTickMode to manual.
    %                     set(gca,'YTickLabel',{'Wrong','Correct'})
    %                     hold on
    %                     plot(delta,answers);
    %                     hold off
    title(sprintf('Up - Down staircase for %s block',test.blocks(block).name)) ;
    xlabel('Trial number');
    ylabel(sprintf('%s (%s)','Stimulus Level',test.blocks(block).step_on));
    margin=(max(delta)-min(delta))/10;
    if   margin~=0
        ylim([min(delta)-margin,max(delta)+margin]);
    end
    % grid on
    while true
        [gx,gy] = ginput(2);
        x1=round(gx(1));
        x2=round(gx(2));
        if x1>=x2
            msgbox('First point must be smaller then second','Warning','modal') ;
            continue;
        else
            break;
        end
    end
    data=delta(x1:x2);
    hold on
    average=mean(data);
    stdev=std(data);
    line([1, n], [average , average],'Color','r','LineWidth',1);
    line([1, n], [average + stdev, average + stdev], 'Color','r','LineWidth',1,'LineStyle','--');
    line([1, n], [average -  stdev, average -  stdev], 'Color','r','LineWidth',1,'LineStyle','--');
    hold off
    dstr=datestr(now, 'dd.mm.HH.MM');
    title(sprintf('Up - Down staircase for %s block ( Mean = %g   STD = %g )',test.blocks(block).name,average,stdev));
end
end