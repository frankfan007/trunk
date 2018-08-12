function varargout = settime(this,t)

if ~isnumeric(t)
    error(sprintf('The input argument should be of type numeric!'));
end

this.time = t;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end

