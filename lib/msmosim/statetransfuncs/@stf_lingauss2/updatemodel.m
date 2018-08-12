function varargout = updatemodel(this, dT, psd )

this.dT = dT;
this.psd = psd;

[F,Q,sQ] = lingauss2( this.dT, this.psd );
this.F = F;
this.Q = Q;
this.srQ = sQ;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
 