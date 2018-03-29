coil_title = 'Circular coil';
x_length = [10];
x_lim = [-5.03,5.03];   %cm

h_f1 = figure(format_figure);
h_f2 = figure(format_figure);

set_axes_6x1;

model_name=['SC_',wvf ,'_RMG'];

filename=fullfile(model_name,[model_name,'_compiled_result.mat']);
load(filename,'compiled_results');

XX_all = compiled_results.XX;
YY_all = compiled_results.YY;
th_CE = compiled_results.th_CE;

R_coil = compiled_results.R_coil;
N_coil = compiled_results.N_coil;

ax_ind_coil = 1;

%% SC UA SC UA SC UA SC UA SC UA SC UA SC UA SC UA SC UA  
suffix = '_UA';
th_UND = compiled_results.(['th',suffix]);
th_per_diff = ( th_UND ./ compiled_results.th_CE - 1) * 100;
th_per_diff(XX_all==0) = -100;

%--------------------------------------------------------------------------
ax_ind_type = 1;
axes(h_ax(ax_ind_type,ax_ind_coil));
contourf(XX_all,YY_all,log10(abs(th_UND )),color_level_amp,'LineStyle','none');

[C,h_contour]=contour(XX_all,YY_all,abs(th_UND ),10.^(ceil(amp_log_min):(floor(amp_log_max)-1)));
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',350);

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

ax_ind_type = 4;
axes(h_ax(ax_ind_type,ax_ind_coil));

contourf(XX_all,YY_all,th_per_diff,color_level_per_full,'LineStyle','none');
%% --------------------------------------------------------------------------

[C,h_contour]=contour(XX_all,YY_all,th_per_diff,[60,60]);
set(h_contour,contour_line,'LineStyle','--');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',200);

ind_Y = find(YY_all(1,:)>=-2);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[20,40]);
set(h_contour,contour_line,'LineStyle','--');
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[0,0]);
set(h_contour,contour_line,'LineWidth',2.5);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[-80,-40]);
set(h_contour,contour_line,'LineStyle','-');

ind_Y = find(YY_all(1,:)<=-2);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[20,40]);
set(h_contour,contour_line,'LineStyle','--');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',200);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[0,0]);
set(h_contour,contour_line,'LineWidth',2.5);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',200);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[-80,-40]);
set(h_contour,contour_line,'LineStyle','-');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',200);

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%% SC UF SC UF SC UF SC UF SC UF SC UF SC UF SC UF SC UF  
suffix = '_UF';
th_UND = compiled_results.(['th',suffix]);
th_per_diff = ( th_UND ./ compiled_results.th_CE - 1) * 100;

th_per_diff(XX_all==0) = -100;

%--------------------------------------------------------------------------
ax_ind_type = 2;
axes(h_ax(ax_ind_type,ax_ind_coil));
contourf(XX_all,YY_all,log10(abs(th_UND )),color_level_amp,'LineStyle','none');

[C,h_contour]=contour(XX_all,YY_all,abs(th_UND ),10.^(ceil(amp_log_min):(floor(amp_log_max)-1)));
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',350);

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

ax_ind_type = 5;
axes(h_ax(ax_ind_type,ax_ind_coil));

contourf(XX_all,YY_all,th_per_diff,color_level_per_full,'LineStyle','none');
%% --------------------------------------------------------------------------

ind_Y = find(YY_all(1,:)>=-2.5);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[10,10]);
set(h_contour,contour_line,'LineStyle','--');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',200);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[0,0]);
set(h_contour,contour_line,'LineWidth',2.5);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',200);
ind_Y = find(YY_all(1,:)<=-2.5);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[10,10]);
set(h_contour,contour_line,'LineStyle','--');
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[0,0]);
set(h_contour,contour_line,'LineWidth',2.5);


ind_Y = find(YY_all(1,:)>=-2);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[-10,-20,-40]);
set(h_contour,contour_line,'LineStyle','-');
ind_Y = find(YY_all(1,:)<=-2);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[-10,-20,-40]);
set(h_contour,contour_line,'LineStyle','-');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',200);

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%% SC UAF SC UAF SC UAF SC UAF SC UAF SC UAF SC UAF SC UAF SC UAF  
suffix = '_UAF';
th_UND = compiled_results.(['th',suffix]);
th_per_diff = ( th_UND ./ compiled_results.th_CE - 1) * 100;

th_per_diff(XX_all==0) = -100;

%--------------------------------------------------------------------------
ax_ind_type = 3;
axes(h_ax(ax_ind_type,ax_ind_coil));
contourf(XX_all,YY_all,log10(abs(th_UND )),color_level_amp,'LineStyle','none');


[C,h_contour]=contour(XX_all,YY_all,abs(th_UND),10.^(ceil(amp_log_min):(floor(amp_log_max)-1)));
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',350);
patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

ax_ind_type = 6;
axes(h_ax(ax_ind_type,ax_ind_coil));

contourf(XX_all,YY_all,th_per_diff,color_level_per_full,'LineStyle','none');
%% --------------------------------------------------------------------------

ind_Y = find(YY_all(1,:)>=-2.5);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),(10:10:40));
set(h_contour,contour_line,'LineStyle','--');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',200);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[0,0]);
set(h_contour,contour_line,'LineWidth',2.5);
ind_Y = find(YY_all(1,:)<=-2.5);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),(10:10:40));
set(h_contour,contour_line,'LineStyle','--');
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[0,0]);
set(h_contour,contour_line,'LineWidth',2.5);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',200);

ind_Y = find(YY_all(1,:)>=-2);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[-40,-40]);
set(h_contour,contour_line,'LineStyle','-');
ind_Y = find(YY_all(1,:)<=-2);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[-40,-40]);
set(h_contour,contour_line,'LineStyle','-');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',200);

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%%
frame = getframe(h_f1);
im_1u = frame2im(frame);
im_1u = im_1u(:,1:round( (x_begin(1) + x_length(1)+x_gap/2) * x_unit * figure_length_x),:);
close(h_f1);

frame = getframe(h_f2);
im_1d = frame2im(frame);
im_1d = im_1d(:,1:round( (x_begin(1) + x_length(1)+x_gap/2) * x_unit * figure_length_x),:);
close(h_f2);
