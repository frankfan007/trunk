 function varargout = allpersistent( inpars )
 
 for j=1:length(inpars)
    inpars(j).weights = ones(size(inpars(j).weights))/( size(inpars(j).states, 2) );
 end
 
 
if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),inpars);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = inpars;
end