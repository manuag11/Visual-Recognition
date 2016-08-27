function displayDetectedSIFTFeatures_all(im1, im2, f1, f2, d1, d2)
% f1, f2 and d1, d2 are the frames and descriptors provided by VLFeat
% im1 and im2 are the associated images

clf;
subplot(1,2,1);
imshow(im1);
axis equal ; axis off ; axis tight ;

hold on ;
sel  = 1:size(f1,2);
h1   = vl_plotframe(f1(:,sel)) ; set(h1,'color','k','linewidth',3) ;
h2   = vl_plotframe(f1(:,sel)) ; set(h2,'color','y','linewidth',2) ;

delete([h1 h2]);

h3 = vl_plotsiftdescriptor(d1(:,sel),f1(:,sel)) ;
set(h3,'color','k','linewidth',2) ;
h4 = vl_plotsiftdescriptor(d1(:,sel),f1(:,sel)) ;
set(h4,'color','g','linewidth',1) ;
h1   = vl_plotframe(f1(:,sel)) ; set(h1,'color','k','linewidth',3) ;
h2   = vl_plotframe(f1(:,sel)) ; set(h2,'color','y','linewidth',2) ;


subplot(1,2,2);
imshow(im2);
axis equal ; axis off ; axis tight ;

hold on ;
sel  = 1:size(f2,2);
h1   = vl_plotframe(f2(:,sel)) ; set(h1,'color','k','linewidth',3) ;
h2   = vl_plotframe(f2(:,sel)) ; set(h2,'color','y','linewidth',2) ;

delete([h1 h2]);

h3 = vl_plotsiftdescriptor(d2(:,sel),f2(:,sel)) ;
set(h3,'color','k','linewidth',2) ;
h4 = vl_plotsiftdescriptor(d2(:,sel),f2(:,sel)) ;
set(h4,'color','g','linewidth',1) ;
h1   = vl_plotframe(f2(:,sel)) ; set(h1,'color','k','linewidth',3) ;
h2   = vl_plotframe(f2(:,sel)) ; set(h2,'color','y','linewidth',2) ;

