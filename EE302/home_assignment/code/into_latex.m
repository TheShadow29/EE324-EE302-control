function [] = into_latex(M)
    [n11,d11] = numden(M);
    M2 = n11/d11
    latex(M2)
end
