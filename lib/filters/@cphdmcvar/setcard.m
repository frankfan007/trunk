function varargout = setcard(this, card )
% SETCARD sets the posterior cardinality
%

if ~isempty( card )
    this.postcard = card/sum(card);
end


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
