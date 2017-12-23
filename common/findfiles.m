function varargout =findfiles(dire,ext)
%the directory you want to find files
%extension name of the files you want to find

% dire=[matlabroot,filesep,'bin\win32'];
% ext='dll';

% output varargout{1} = [all files path];
%        varargout{2} = [all folders include those files specified];

%check if the input and output is valid
if ~isdir(dire)
    msgbox('The input isnot a valid directory','Warning','warn');
    return
else
    if nargin==1
        ext='*';
    elseif nargin>2||nargin<1
        msgbox('1 or 2 inputs are required','Warning','warn');
        return
    end
%     if nargout>1
%         msgbox('Too many output arguments','Warning','warn');
%         return
%     end
%     
    %containing the searching results
    D={};
    
    %containing all the directories on the same class
    folder{1}=dire;
    flag=1; %1 when there are folders havenot be searched,0 otherwise
    while flag
        currfolders=folder;
        folder={};
        
        for m=1:1:length(currfolders)
            direc=currfolders{m};
            files=dir([direc,filesep,'*.',ext]);
            
            %the number of *.ext files in the current searching folder
            L=length(files);   
            temp = {};
            for ii = 1:L
                temp{ii}=[direc,filesep,files(ii).name];
            end
            if ~isempty(temp)                
                num=length(D);
                D{num+1}=temp; 
            end
            allfiles=dir(direc);%subfolders and files in current foleder
            %the number of all the files in the current searching folder
            L=length(allfiles);
            %the number of folders to be searched on this class
            k=length(folder);
            for i=1:1:L
                if allfiles(i).isdir&&(~strcmp(allfiles(i).name,'.'))&&~strcmp(allfiles(i).name,'..')
                    k=k+1;
                    folder{k}=[direc,filesep,allfiles(i).name];%save all folder name in the same level
                end
            end
        end
        
        %if there are no folders that havenot searched yet,flag=0 so the loop
        %will be ended 
        if isempty(folder)
            flag=0;
        end
    end
    varargout{1} = D';
    varargout{2} = currfolders';
end