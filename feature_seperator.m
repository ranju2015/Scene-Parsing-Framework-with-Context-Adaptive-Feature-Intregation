for i = 1:length(trainSegFeat)
   
    switch trainSegGT(i,1)
    case 1 
           temp =trainSegFeat(i,:);
           trainsegFeat_class_1 = [trainsegFeat_class_1;temp];
           temp2 = [i , trainSegGT(i,1)];
           trainsegGT_class_1 = [trainsegGT_class_1 ; temp2];
    case 2 
           temp =trainSegFeat(i,:); 
           trainsegFeat_class_2 =[trainsegFeat_class_1;temp];
           temp2 = [i , trainSegGT(i,1)];
           trainsegGT_class_2 = [trainsegGT_class_1 ; temp2];
    case 3 
        temp =trainSegFeat(i,:);   
        trainsegFeat_class_3 = [trainsegFeat_class_1;temp];
        temp2 = [i , trainSegGT(i,1)];   
        trainsegGT_class_3 = [trainsegGT_class_1 ; temp2];
    case 4 
           temp =trainSegFeat(i,:);
           trainsegFeat_class_4 = [trainsegFeat_class_1;temp];
           temp2 = [i , trainSegGT(i,1)];   
           trainsegGT_class_4 = [trainsegGT_class_1 ; temp2];
    case 5 
           temp =trainSegFeat(i,:);
           trainsegFeat_class_5 = [trainsegFeat_class_1;temp];
           temp2 = [i , trainSegGT(i,1)];   
           trainsegGT_class_5 = [trainsegGT_class_1 ; temp2];
    case 6 
           temp =trainSegFeat(i,:);
           trainsegFeat_class_6 = [trainsegFeat_class_1;temp];
           temp2 = [i , trainSegGT(i,1)];   
           trainsegGT_class_6 = [trainsegGT_class_1 ; temp2];
    case 7 
           temp =trainSegFeat(i,:);
           trainsegFeat_class_7 = [trainsegFeat_class_1;temp];
           temp2 = [i , trainSegGT(i,1)];   
           trainsegGT_class_7 = [trainsegGT_class_1 ; temp2];
    case 8 
           temp =trainSegFeat(i,:);
           trainsegFeat_class_8 = [trainsegFeat_class_1;temp];
           temp2 = [i , trainSegGT(i,1)];   
           trainsegGT_class_8 = [trainsegGT_class_1 ; temp2];

    otherwise
        warning('Unexpected Superpixel Class Type')
    end
    
end
