function varargout = drawc(these, varargin)
states_ = these.catstates;
weights = these.catweights;
clusterlabels = these.getlastlabel;
clusterNames = unique( clusterlabels,'legacy' );

dims = [1,2];


plotOpt = {'''Marker'',''x'',''LineStyle'',''None'''};

figureHandle = [];
axisHandle = [];
legendOn = 0;
precommands = '';
postcommands = '';

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    
    if isa( varargin{argnum} , 'char')
        switch lower(varargin{argnum})
            case {'axis'}
                if argnum + 1 <= nvarargin
                    axisHandle = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'figure'}
                if argnum + 1 <= nvarargin
                    figureHandle = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'dims','dimensions'}
                if argnum + 1 <= nvarargin
                    dims = varargin{argnum+1}(:);
                    argnum = argnum + 1;
                end
                
            case {'postcommands'}
                if argnum + 1 <= nvarargin
                    postcommands = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'options'}
                if argnum + 1 <= nvarargin
                    plotOpt = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'precommands'}
                if argnum + 1 <= nvarargin
                    precommands = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'legend'}
                legendOn = 1;
                
                
            otherwise
                error('Wrong input string');
        end
    end
    argnum = argnum + 1;
end

if isempty(axisHandle)
    if isempty(figureHandle)
        figureHandle = figure;
    end
    axisHandle = gca;
end

dstates_ = [states_([1,2],:); weights' ];

% Sort the clusters that are not labelled as zero according to their
% weights
clusterNames = sort( unique( clusterlabels,'legacy' ) );
nzclusters = clusterNames( find(clusterNames~=0) );
nzclusterweights = [];

for i=1:length( nzclusters )
    indx = find( clusterlabels == nzclusters(i) );
    nzclusterweights(i) = sum( weights(indx) );
end

[sweights, nzind ] = sort( nzclusterweights, 'descend' );

if isempty(axisHandle)
    if isempty(figureHandle)
        figureHandle = figure;
    end
    axisHandle = gca;
end

rgbObj = rgb;
axes(axisHandle);
if ~isempty(precommands)
    eval(precommands);
end
hold on
grid on

lHandles = [];
lString = '';

% First, draw the zero labels
indx = find( clusterlabels == 0 );
if ~isempty( indx  )
    colstr = num2str( getcol(rgbObj) );
     tw = sum( weights(indx) );
    eval(['l = plot3(dstates_(1,indx), dstates_(2,indx), dstates_(3,indx),', ...
        [plotOpt{1},',''Color'',[', colstr ,']'],');'] );
    lHandles = [ lHandles, l ]; 
    lString = [lString,'''',num2str( 0 ),'(', num2str(tw),')'','];
     getcol(rgbObj); % Waste the second
else
    getcol(rgbObj); % Waste the first
     getcol(rgbObj); % Waste the second
end

% Then, the non-zero labelled clusters
if ~isempty( nzclusters )
    for i=1:length(nzind)
        clabel =  nzclusters( nzind( i ) );
        indx = find( clusterlabels == clabel );
        tw = sweights(i);
        
        colstr = num2str( getcol(rgbObj) );
       
        
        eval(['l = plot3(dstates_(1,indx), dstates_(2,indx), dstates_(3,indx),', ...
            [plotOpt{1},',''Color'',[', colstr ,']'],');'] );
        lHandles = [ lHandles, l ];
        lString = [lString,'''',num2str( clabel ),'(', num2str(tw),')'','];
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if legendOn
   eval(['legend(lHandles,',lString(1:end-1),');']); 
end
if ~isempty(postcommands)
    eval( postcommands)
end     
hold off

if nargout>=1
    varargout{1} = axisHandle;
end
if nargout>=2
    varargout{2} = figureHandle;
end

