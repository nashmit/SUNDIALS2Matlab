function outp = integrateWSensitiviesAndHessian(inp)
    outp = ComputeIntegration(inp);
    outp.G = ComputeJacobian(inp).G;
    outp.H = ComputeHessian(inp).H;
    
end