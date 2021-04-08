% author : serge brosset
% condyle segmentation of small FOV CBCT scans


function TMJSeg(filename)

    display(filename);
        
    volume = niftiread(filename);
    S = size(volume);

    info = niftiinfo(filename);
    info.Datatype = 'int8'; 
    info.BitsPerPixel = 8;
    info.Filemoddate = {};



    % median filtering + guided filter / denoisiong
    Imedian = medfilt3(volume,[7 7 7]);
    Ifiltered = imguidedfilter(Imedian);


    % delete value out of image (< 0)
    Ifiltered(Ifiltered<0) = 0;



    % contrast adjustement
    Idb = im2double(Ifiltered);
    M = max(Idb(:));
    m = min(Idb(:));
    Iadjust = (imadjustn(Idb,[m M],[0 1]));    


    % get contour of the shape
    Iedge = edge3(Iadjust,"approxcanny",graythresh(Iadjust));



    % remove small objects
    BW = bwareaopen(Iedge,100000); 


    % remove all components but the condyle
    CC = bwconncomp(BW);numPixels = cellfun(@numel,CC.PixelIdxList);numOb = CC.NumObjects;

    % check for cond/bones without separations
    if numOb < 2

        sigma = 0.1;
        Iedge = edge3(Iadjust,"approxcanny",graythresh(Iadjust),sigma);
        BW = bwareaopen(Iedge,100000);
        CC = bwconncomp(BW);numPixels = cellfun(@numel,CC.PixelIdxList);numOb = CC.NumObjects;

        while numOb < 2
            sigma = sigma + 0.5;
            Iedge = edge3(Iadjust,"approxcanny",graythresh(Iadjust),sigma);
            BW = bwareaopen(Iedge,100000);
            CC = bwconncomp(BW);numPixels = cellfun(@numel,CC.PixelIdxList);numOb = CC.NumObjects;

            % break while condition
            if sigma > 10
                break;
                disp('error');
            end

        end   
        [~,idMax] = max(numPixels);
        BW(CC.PixelIdxList{idMax}) = 0;

    else

        [~,idMax] = max(numPixels);
        BW(CC.PixelIdxList{idMax}) = 0;
        CC = bwconncomp(BW);numPixels = cellfun(@numel,CC.PixelIdxList);

        while CC.NumObjects > 2
            [~,idMax] = max(numPixels);
            BW(CC.PixelIdxList{idMax}) = 0;
            CC = bwconncomp(BW);
            numPixels = cellfun(@numel,CC.PixelIdxList);
        end

        CC = bwconncomp(BW);numPixels = cellfun(@numel,CC.PixelIdxList);

    end

    condyle = BW;



    % 2D convex uhull to fill the shape
    newImg1 = zeros(S);
    newImg2 = zeros(S);
    newImg3 = zeros(S);
    for j = 1:S(3)
        ch = bwconvhull(condyle(:,:,j),'objects');
        newImg1(:,:,j) = ch;
    end
    for j = 1:S(2)
        ch = bwconvhull(squeeze(condyle(:,j,:)),'objects');
        newImg2(:,j,:) = ch;
    end
    for j = 1:S(1)
        ch = bwconvhull(squeeze(condyle(j,:,:)),'objects');
        newImg3(j,:,:) = ch;
    end

    CHe = newImg1 & newImg2 & newImg3;  

    shape = CHe;



    % active contour to get more accurate contour
    SE = strel("sphere",11);
    Iclose = imclose(shape,SE);
    Ifill = imfill(Iclose,'holes');


    I = niftiread(filename);
    I = imguidedfilter(I);
    I16 = uint16(I);
    Id = im2double(I16);


    % 30 -> 20 iterations
    Iac = activecontour(Id,Ifill,20);
    Iac = bwareaopen(Iac,10000); % remove small pixels alone



    
    % save output 
    % read format : name.nii / name.nii.gz

    [filepath,name,ext] = fileparts(filename);
    name = strcat(name,ext);

    filenamesplit = split(name, '.');
    nameChar = cell2mat(filenamesplit(1));

    seg_name = strcat(nameChar, '_seg', '.', cell2mat(filenamesplit(2)));
    seg_fullname = strcat(filepath, '/', seg_name);

    info.Filename = seg_name;

    niftiwrite(int8(Iac),seg_fullname,info);


    if (contains(filename, '.gz'))
        gzip(seg_fullname);
        delete(seg_fullname);
    end

        

 
end