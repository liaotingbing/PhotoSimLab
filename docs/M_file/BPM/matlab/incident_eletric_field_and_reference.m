for cidx = 1:nz

    eps_z = eps(:, :, cidx);
    eps_x = interp1(x, eps_z, xm, "linear", "extrap");
    eps_y = interp1(y, eps_z', ym, "linear", "extrap")';

    EPS_X = spdiags(eps_x(:), 0, nt, nt);
    EPS_Y = spdiags(eps_y(:), 0, nt, nt);
    EPS_Z = spdiags(eps_z(:), 0, nt, nt);

    MU_X = speye(nt);
    MU_Y = speye(nt);
    MU_Z = speye(nt);

    Pxx = -Ux * inv(EPS_Z) * Vy;
    Pxy = Ux * inv(EPS_Z) * Vx + MU_Y;
    Pyx = -Uy * inv(EPS_Z) * Vy - MU_X;
    Pyy = Uy * inv(EPS_Z) * Vx;

    P = [Pxx, Pxy; Pyx, Pyy];

    Qxx = -Vx * inv(MU_Z) * Uy;
    Qxy = Vx * inv(MU_Z) * Ux + EPS_Y;
    Qyx = -Vy * inv(MU_Z) * Uy - EPS_X;
    Qyy = Vy * inv(MU_Z) * Ux;

    Q = [Qxx, Qxy; Qyx, Qyy];


    nmodes_max = 20;
    [et_, d] = eigs(-P*Q, nmodes_max, max(eps_z, [], "all"));
    neff_ = sqrt(diag(d));
    sd = ones(nmodes_max, 1);
    for i = 1:nmodes_max - 1
        if abs(neff_(i)-neff_(i+1)) < 1e-6
            % sd(i) = 0;
            % sd(i+1) = 0;
        end
    end
    neff = neff_(sd > 0);
    et = et_(:, sd > 0);
    ex = reshape(et(1:nt, :), nx, ny, []);
    ey = reshape(et(nt+1:2*nt, :), nx, ny, []);

    %%

    if cidx == 1
        ex_inc = real(ex(:, :, input_mode_select));
        ey_inc = real(ey(:, :, input_mode_select));
        f = "ex_inc_mode_" + num2str(input_mode_select) + ".txt";
        save(f, "ex_inc", "-ascii");
        f = "ey_inc_mode_" + num2str(input_mode_select) + ".txt";
        save(f, "ey_inc", "-ascii");
    end

    K0 = neff(input_mode_select);
    neff_list(cidx, 1) = K0;
    fprintf("z=%d, neff=%d\n", z(cidx), K0);

end
%%
neff_list_ = real(neff_list);
save("neff_list.dat", "neff_list_", "-ascii");

%% 画输入场图


if plot_incident_field == 0
    figure
    subplot(211)
    pcolor(xm, y, ex_inc')
    title("Ex")
    xlabel("X (um)")
    ylabel("Y (um)")
    shading interp
    colormap jet
    colorbar
    % axis equal

    subplot(212)
    pcolor(x, ym, ey_inc')
    title("Ey")
    xlabel("X (um)")
    ylabel("Y (um)")
    shading interp
    colormap jet
    colorbar
    % axis equal

    f = sprintf("横向电场 模式#%d 有效折射率=%d", input_mode_select, (neff_list(1)));
    sgtitle(f)
    set(gcf , "outerPosition" , get(0, "ScreenSize"))
    % set(gcf , "Position",[50,50 1200 800])
    exportgraphics(gcf , "incident_eletric_field.png");
    % close;
end

%%


plot(z, neff_list)
xlabel("Z (um)")
ylabel("有效折射率")
set(gcf , "OuterPosition",get(0, "ScreenSize"))
exportgraphics(gcf , "effective_neff.png")
