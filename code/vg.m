function [eye,para_list,DEM_error,DEM_error_abs]=vg(name,folder,interval,isfliplr,issave)
% name: type id, 1 means type A
% folder: folder name of type id's results
% interval: contour interval value (ignored)
% isfliplr: if the x axis value need to resort asign to visual direction
% issave: if figures are saved into tiff pics
% Example:
% vg('4','4.2-1',30);
% vg('4','1-2-A4',30);
% vg(1,'4-2-A1',30,true,false)
clc;
close all;
set(0,'DefaultTextFontname', 'Times New Roman')
set(0,'DefaultAxesFontName', 'Times New Roman')
% set(gcf,'color','white');
% or in figure's property editor

%% 注意
% 在C++程序中，数据读入系统后，已进行系数拉伸（mesh->normalize_scale）
% 该初始拉伸操作以及后续自定义拉伸操作对数据进行了线性拉伸，是否改变形状？
% 从而影响道格拉斯的简化结果？初步估计：不会影响。待仔细考虑。
%% 为了定义三维视图中的视线方向，先进行步骤2，再进行步骤1
% define figure list
% figure,filename
fig_list={1,2};
fig_dir='';
if(issave)
    fig_dir=uigetdir('','选择存储目录');
%     if(strcmp(fig_dir,''))
%         fig_dir='';
%     end
end
%%
tic;
font_size=12;
% 2.绘制综合前、后的参数曲线图
if(~strcmp(folder,''))
    folder=[folder '\'];
    % 当且仅当folder为非空时，才绘制曲线；否则，只输出原始dem与剩余点
    path_para=['E:\R\1-vision\0-投稿材料\generalData\after\res\' folder 'after_paras_loi.txt'];
    %path_para=['E:\研究\tmp\generalData\Debug\' folder 'after_paras_loi.txt'];
    path_eye=['E:\R\1-vision\0-投稿材料\generalData\after\res\' folder 'after_paras_eye.txt'];
    %path_eye=['E:\研究\tmp\generalData\Debug\' folder 'after_paras_eye.txt'];
    paras=load(path_para);
    para_eye=load(path_eye);
    % ptNum_before,ptNum_after,dmax,domain,dmin,length,width,distance
    ptNum_before=(paras(:,1))';
    ptNum_after=(paras(:,2))';
    ptLossRatio=(ptNum_before-ptNum_after)./ptNum_before;
    dmax=(paras(:,3))';
    domain=(paras(:,4))';
    dmin=(paras(:,5))';
    length=(paras(:,6))';
    width=(paras(:,7))';
    distance=(paras(:,8))';
    % 视点参数——
    eye_x=para_eye(1);
    eye_y=para_eye(2);
    eye_z=para_eye(3);
    scale=para_eye(4);
    eye(1,1)=eye_x;
    eye(1,2)=eye_y;
    eye(1,3)=eye_z;
    %
    num=size(distance(:));
    index=1:1:num;
    
    min_dis=find(distance==min(distance(:)));
    mindis=min(distance(:))*scale
    maxdis=max(distance(:))*scale
    minwid=min(width(:))*scale
    maxwid=max(width(:))*scale
    %   平均长度：水平投影值不变的区域
    meanlen=mean(length(width==max(width(:))))*scale
    scale
    eye
    meanPtLossRatio=mean(ptLossRatio(:))
    % output parameters: para_list
    % para_list(1): minimum of real distance
    para_list(1)=mindis;
    % para_list(2): maximum of real distance
    para_list(2)=maxdis;
    % para_list(3): minimum of real width
    para_list(3)=minwid;
    % para_list(4): maximum of real width
    para_list(4)=maxwid;
    % para_list(5): scale
    para_list(5)=scale;
    % para_list(6): mean simplification ratio of all levels
    para_list(6)=meanPtLossRatio;
    % para_list(7): aspect of eye
    % para_list(8): altitude of eye
    if(~isfliplr)
        %     %% 综合前后点数对比图
        figure(1),
        plot(index,ptNum_before,'-','LineWidth',2);str_ptNum{1}=['Before Simplification'];hold on;
        plot(index,ptNum_after,':','LineWidth',2);str_ptNum{2}=['After Simplification'];hold on;
        plot(index,ptNum_before-ptNum_after,'--','LineWidth',2);str_ptNum{3}=['Point Loss'];
        hold off;
        xlabel('Level Index','fontsize',font_size,'fontweight','b');
        %     ylabel('','fontsize',font_size);
        legend(str_ptNum,'fontsize',font_size,'fontweight','b');
        %grid on;
        % title('Contrast on pt loss number of LOI');
        % vline(min_dis,'r',['min distance=' num2str(distance(min_dis)*scale)]);
        %%
        figure(2),
        plot(index,ptLossRatio,'-ks','LineWidth',1,...
                                   'MarkerEdgeColor','k',...
                                   'MarkerFaceColor','w',...
                                   'MarkerSize',4);str_ptNumLoss{1}=['Simplification Rate'];
        xlabel('Level Index','fontsize',font_size,'fontweight','b');
        ylabel('Simplification Rate','fontsize',font_size,'fontweight','b');
        %         legend(str_ptNumLoss,'fontsize',font_size);
        %grid on;
        
        fig_list{1,1}=gcf;fig_list{1,2}=[fig_dir '\' folder(1:3) '-sim_rate.tiff'];

        %% 综合时阈值变化情况
        figure(3),
        plot(index,dmax,'-k','LineWidth',3);str_domain1{1}=['Maxmum'];hold on;
%         plot(index,domain,'-ks','LineWidth',2,...
%                               'MarkerEdgeColor','k',...
%                               'MarkerFaceColor','w',...
%                               'MarkerSize',4);str_domain1{2}=['Depth-based'];
        plot(index,domain,':k','LineWidth',2);str_domain1{2}=['Depth-based'];
        hold off;
        xlabel('Level Index','fontsize',font_size,'fontweight','b');
        ylabel('Domain (m)','fontsize',font_size,'fontweight','b');
        legend(str_domain1,'fontsize',font_size,'fontweight','b');
        %grid on;
        % title('Contrast on domain & dmax of LOI');
        % vline(min_dis,'r',['min distance=' num2str(distance(min_dis)*scale)]);
        %%
        figure(4),
%         plot(index,domain,'-ks','LineWidth',1,...
%                               'Marker','^',...
%                               'MarkerEdgeColor','k',...
%                               'MarkerFaceColor','w',...
%                               'MarkerSize',5);str_domain2{1}=['Depth-based'];hold on;
        plot(index,domain,':k','LineWidth',2);str_domain2{1}=['Depth-based'];hold on;
        plot(index,dmin,'-k','LineWidth',2);str_domain2{2}=['Minimum'];
        hold off;
        xlabel('Level Index','fontsize',font_size,'fontweight','b');
        ylabel('Domain (m)','fontsize',font_size,'fontweight','b');
        legend(str_domain2,'fontsize',font_size,'fontweight','b');
        %grid on;
        
        fig_list{2,1}=gcf;fig_list{2,2}=[fig_dir '\' folder(1:3) '-Depth_Min.tiff'];
        % title('Contrast on domain & dmin of LOI');
        % vline(min_dis,'r',['min distance=' num2str(distance(min_dis)*scale)]);
        %%
        figure(5),
        plot(index,dmax,'-k','LineWidth',3);str_domain3{1}=['Maximum'];hold on;
%         plot(index,domain,'-ks','LineWidth',1,...
%                               'MarkerEdgeColor','k',...
%                               'MarkerFaceColor','w',...
%                               'MarkerSize',4);str_domain3{2}=['Depth-based'];hold on;
        plot(index,domain,':k','LineWidth',2);str_domain3{2}=['Depth-based'];hold on;
        plot(index,dmin,'-k','LineWidth',2);str_domain3{3}=['Minimum'];
        hold off;
        xlabel('Level Index','fontsize',font_size,'fontweight','b');
        ylabel('Domain (m)','fontsize',font_size,'fontweight','b');
        legend(str_domain3,'fontsize',font_size,'fontweight','b');
%         axis([0 500 -0.1 1]);
        %grid on;
        
        fig_list{3,1}=gcf;fig_list{3,2}=[fig_dir '\' folder(1:3) '-Max_Depth_Min.tiff'];
        % title('Contrast on dmax & domain & dmin of LOI');
        % vline(min_dis,'r',['min distance=' num2str(distance(min_dis)*scale)]);
        %% 综合时链结构长度、水平投影长度与景深的关系
        figure(6),
        plot(index,distance.*scale,'-k','LineWidth',3);str_dislen{1}=['Depth'];hold on;
        plot(index,length.*scale,':k','LineWidth',2);str_dislen{2}=['Length'];hold on;
        plot(index,width.*scale,'-k','LineWidth',2);str_dislen{3}=['Width'];
        hold off;
        xlabel('Level Index','fontsize',font_size,'fontweight','b');
        ylabel('(m)','fontsize',font_size,'fontweight','b');
        legend(str_dislen,'fontsize',font_size,'fontweight','b');
        %grid on;
        
        fig_list{4,1}=gcf;fig_list{4,2}=[fig_dir '\' folder(1:3) '-DLW.tiff'];
    else
        % % %     fliplr
        %% 综合前后点数对比图fliplr
        f_ptNum_before=fliplr(ptNum_before);
        f_ptNum_after=fliplr(ptNum_after);
        f_ptNum_before=fliplr(ptNum_before);
        f_ptLossRatio=fliplr(ptLossRatio);
        f_dmax=fliplr(dmax);
        f_domain=fliplr(domain);
        f_dmin=fliplr(dmin);
        f_distance=fliplr(distance);
        f_length=fliplr(length);
        f_width=fliplr(width);
        f_pos_middle=(f_width==max(f_width(:)));
        disp(['middle width: ' num2str(max(f_width(:)).*scale)]);
        middle_dis=f_distance(f_pos_middle);
        disp(['middle min_dis: ' num2str(min(middle_dis(:)).*scale)]);
        disp(['middle max_dis: ' num2str(max(middle_dis(:)).*scale)]);
        %%
        figure(1),
        plot(index(f_pos_middle),f_ptNum_before(f_pos_middle),'-','LineWidth',2);str_ptNum{1}=['Before Simplification'];hold on;
        plot(index(f_pos_middle),f_ptNum_after(f_pos_middle),'r-','LineWidth',2);str_ptNum{2}=['After Simplification'];hold on;
        plot(index(f_pos_middle),f_ptNum_before(f_pos_middle)-f_ptNum_after(f_pos_middle),'g-','LineWidth',2);str_ptNum{3}=['Point Loss'];
        hold off;
        xlabel('Level Index','fontsize',font_size,'fontweight','b');
        %     ylabel();
        legend(str_ptNum,'fontsize',font_size,'fontweight','b');
        %grid on;
        % title('Contrast on pt loss number of LOI');
        % vline(min_dis,'r',['min distance=' num2str(distance(min_dis)*scale)]);
        %%
        figure(2),
%         plot(index(f_pos_middle),f_ptLossRatio(f_pos_middle),'-','LineWidth',2);str_ptNumLoss{1}=['Simplification Rate'];
        plot(index(f_pos_middle),f_ptLossRatio(f_pos_middle),'-ks','LineWidth',1,...
                                   'MarkerEdgeColor','k',...
                                   'MarkerFaceColor','w',...
                                   'MarkerSize',4);str_ptNumLoss{1}=['Simplification Rate'];
        xlabel('Level Index','fontsize',font_size,'fontweight','b');
        ylabel('Simplification Rate','fontsize',font_size,'fontweight','b');
        %     legend(str_ptNumLoss,'fontsize',font_size);
        %grid on;
        
        fig_list{1,1}=gcf;fig_list{1,2}=[fig_dir '\' folder(1:3) '-sim_rate_cut.tiff'];
        %
        %% 综合时阈值变化情况
        figure(3),
        plot(index(f_pos_middle),f_dmax(f_pos_middle),'-k','LineWidth',3);str_domain1{1}=['Maxmum'];hold on;
        plot(index(f_pos_middle),f_domain(f_pos_middle),':k','LineWidth',2);str_domain1{2}=['Depth-based'];
        hold off;
        xlabel('Level Index','fontsize',font_size,'fontweight','b');
        ylabel('Domain (m)','fontsize',font_size,'fontweight','b');
        legend(str_domain1,'fontsize',font_size,'fontweight','b');
        %grid on;
        % title('Contrast on domain & dmax of LOI');
        % vline(min_dis,'r',['min distance=' num2str(distance(min_dis)*scale)]);
        %%
        figure(4),
        plot(index(f_pos_middle),f_domain(f_pos_middle),':k','LineWidth',2);str_domain2{1}=['Depth-based'];hold on;
        plot(index(f_pos_middle),f_dmin(f_pos_middle),'-k','LineWidth',2);str_domain2{2}=['Minimum'];
        hold off;
        xlabel('Level Index','fontsize',font_size,'fontweight','b');
        ylabel('Domain (m)','fontsize',font_size,'fontweight','b');
        legend(str_domain2,'fontsize',font_size,'fontweight','b');
        %grid on;
        
        fig_list{2,1}=gcf;fig_list{2,2}=[fig_dir '\' folder(1:3) '-Depth_Min_cut.tiff'];
        % title('Contrast on domain & dmin of LOI');
        % vline(min_dis,'r',['min distance=' num2str(distance(min_dis)*scale)]);
        %%
        figure(5),
        plot(index(f_pos_middle),f_dmax(f_pos_middle),'-k','LineWidth',3);str_domain3{1}=['Maximum'];hold on;
        plot(index(f_pos_middle),f_domain(f_pos_middle),':k','LineWidth',2);str_domain3{2}=['Depth-based'];hold on;
        plot(index(f_pos_middle),f_dmin(f_pos_middle),'-k','LineWidth',2);str_domain3{3}=['Minimum'];
        hold off;
        xlabel('Level Index','fontsize',font_size,'fontweight','b');
        ylabel('Domain (m)','fontsize',font_size,'fontweight','b');
        legend(str_domain3,'fontsize',font_size,'fontweight','b');
        %grid on;
        
        fig_list{3,1}=gcf;fig_list{3,2}=[fig_dir '\' folder(1:3) '-Max_Depth_Min_cut.tiff'];
        %% %     whole
        figure(6),
        plot(index,f_dmax,'-k','LineWidth',3);str_domain3{1}=['Maximum'];hold on;
        plot(index,f_domain,':k','LineWidth',2);str_domain3{2}=['Depth-based'];hold on;
        plot(index,f_dmin,'-k','LineWidth',2);str_domain3{3}=['Minimum'];
        hold off;
        xlabel('Level Index','fontsize',font_size,'fontweight','b');
        ylabel('Domain (m)','fontsize',font_size,'fontweight','b');
        legend(str_domain3,'fontsize',font_size,'fontweight','b');
        %grid on;
        
        fig_list{4,1}=gcf;fig_list{4,2}=[fig_dir '\' folder(1:3) '-Max_Depth_Min.tiff'];
        % title('Contrast on dmax & domain & dmin of LOI');
        % vline(min_dis,'r',['min distance=' num2str(distance(min_dis)*scale)]);
        %% 综合时链结构长度、水平投影长度与景深的关系
        figure(7),
        plot(index(f_pos_middle),f_distance(f_pos_middle).*scale,'-k','LineWidth',3);str_dislen{1}=['Depth'];hold on;
        plot(index(f_pos_middle),f_length(f_pos_middle).*scale,':k','LineWidth',2);str_dislen{2}=['Length'];hold on;
        plot(index(f_pos_middle),f_width(f_pos_middle).*scale,'-k','LineWidth',2);str_dislen{3}=['Width'];
        hold off;
        xlabel('Level Index','fontsize',font_size,'fontweight','b');
        ylabel('(m)','fontsize',font_size,'fontweight','b');
        legend(str_dislen,'fontsize',font_size,'fontweight','b');
        %grid on;
        
        fig_list{5,1}=gcf;fig_list{5,2}=[fig_dir '\' folder(1:3) '-DLW_cut.tiff'];
        % %     whole
        figure(8),
        plot(index,f_distance.*scale,'-k','LineWidth',3);str_dislen{1}=['Depth'];hold on;
        plot(index,f_length.*scale,':k','LineWidth',2);str_dislen{2}=['Length'];hold on;
        plot(index,f_width.*scale,'-k','LineWidth',2);str_dislen{3}=['Width'];
        hold off;
        xlabel('Level Index','fontsize',font_size,'fontweight','b');
        ylabel('(m)','fontsize',font_size,'fontweight','b');
        legend(str_dislen,'fontsize',font_size,'fontweight','b');
        %grid on;
        
        fig_list{6,1}=gcf;fig_list{6,2}=[fig_dir '\' folder(1:3) '-DLW.tiff'];
    end
    % % %
    % title('Length & Width of LOI after Generaliztion');
    % vline(min_dis,'r',['min distance=' num2str(distance(min_dis)*scale)]);
    %
    % 根据eye计算视点方位角和仰角
    % 传入PointCloud3D函数
    if(eye(1,1)~=0)
        view_condition(1)=180*atan(eye(1,2)/eye(1,1))/pi;
    else
        view_condition(1)=0;
    end
    view_condition(2)=180*atan(eye(1,3)/sqrt(eye(1,1)*eye(1,1)+eye(1,2)*eye(1,2)))/pi;
else
    view_condition(1)=-37.5;
    view_condition(2)=30;
end
para_list(7)=view_condition(1);
para_list(8)=view_condition(2);
view_condition

%%
if(issave)
    [num_fig]=save_figures(fig_list);
    disp([num2str(num_fig) ' figures are saved......']);
else
    disp('No figure is saved......');
end
toc;

%% 为了定义三维视图中的视线方向，先进行步骤2，再进行步骤1
% % % % 1.绘制综合前、后的等高线和DEM进行对边显示
% % % path_before=['E:\研究\tmp\generalData\before\' name '.txt'];
% % % % if(~strcmp(folder,''))
% % % %     folder=[folder '\'];
% % % % end
% % % path_after=['E:\研究\tmp\generalData\after\res\' folder 'after_pts_left.txt'];
% % % %path_after=['E:\研究\tmp\generalData\Debug\' folder 'after_pts_left.txt'];
% % %
% % % before=load(path_before);
% % % after=load(path_after);
% % %
% % % % 绘制相关视图
% % % [DEM_B]=PointCloud3D(before,'before',interval,view_condition);
% % % [DEM_A]=PointCloud3D(after,'after',interval,view_condition);
% % % %% 绘制DEM前后差值图
% % % [row,col]=size(DEM_B-DEM_A);
% % % figure,imagesc([0,col],[row,0],DEM_B-DEM_A);
% % % % colorbar;
% % % figure,imagesc([0,col],[row,0],abs(DEM_B-DEM_A));
% % % % colorbar;
% % % hold on;
% % % % title('Eleveation variance after generaliztion');
% % % % figure
% % % % interval为等高距
% % % DEM_error=DEM_B-DEM_A;
% % % DEM_error_abs=abs(DEM_B-DEM_A);
% % % % step=[min(absDEM(:)):30:max(absDEM(:))];%等高距30
% % % % [C,h]=contour([row,0],[0,col],abs(DEM_B-DEM_A),step,'COLOR',[0,0,0]);
% % % % hold off;
%

end
function [num]=save_figures(fig_list)
% 4-DLW_cut: legend location is not proper
% print(figure(7),'-dtiff','-cmyk','-r300','E:\研究\tmp\pic2\4-2-DLW_cut.tiff
% ');
num=size(fig_list,1);
disp(['figure numbers=' num2str(num)]);
for i=1:num
    %     fig_list{i,1}
%     print(fig_list{i,1},'-dtiff','-cmyk','-r300',fig_list{i,2});
    set(fig_list{i,1},'paperpositionmode','auto');%'color','white',
    saveas(fig_list{i,1},fig_list{i,2});
    
    disp([fig_list{i,2} ' is saved......']);
end
end
