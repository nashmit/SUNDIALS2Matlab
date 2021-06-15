%integrateWSensitivies 
%
% integrates the system and computes the forward sensitivities with respect to x_0 and q
%
% 
function outp = integrateWSensitivies(inp)
    outp = ComputeIntegration(inp);
    outp.G = ComputeJacobian(inp).G;
    
end