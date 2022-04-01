names = {'Sky' 'Tree' 'Road' 'Grass' 'Water' 'Bldng' 'Mountain' 'Foreground'};
load('0105146_SPAG1.mat');
G_new = graph(adjSuperPixelOcc_2,names);
LWidths = 2*G_new.Edges.Weight/max(G_new.Edges.Weight);

plot(G_new,'Layout','force','EdgeLabel',G_new.Edges.Weight,'LineWidth',LWidths)