function write_fun(FID,STR)
% write_fun(FID,STR) displays in command window for FID = 0, or writes in
% file given by FID. STR is cell array of strings.

if ~FID
    for ii = 1: length(STR)
        disp(STR{ii});
    end
else
    for ii = 1: length(STR)
        ind = find( (STR{ii} == '%') | (STR{ii} == '\') );          % Deal with escape characters '%' & '\'
        for jj = 1: length(ind)
            STR{ii} = [STR{ii}(1:ind(jj)),STR{ii}(ind(jj):end)];    % Duplicate escape characters
            ind(jj+1:end) = ind(jj+1:end) + 1;
        end        
        fprintf(FID,[STR{ii},'\n']);
    end
end