function vba_df=create_vba_mfx_input_trust()
%Create the input for VBA_MFX analysis on the trust game clinical data

%END HLEP

models = {'f_trust_Qlearn_policy'};

for model = models
    
    %Initialize the tbale
    vba_df = table();
    
    %Use glob to pull all the vba files
        data_path = 'E:/Box Sync/skinner/projects_analyses/Project Trust/data/model-derived/clinical_scan_models/';
        vba_files = glob([data_path model{:} '/*.mat']);

    
    %File loop
    for vba_file = vba_files'
        load(vba_file{:}, 'out') %Load in the file should contain b,out,posterior
        close all; %Remove figures
        id = regexp(vba_file{:}, '[0-9]{4,6}', 'match');
        id = str2double(id{:});
        
        %Initialize temporay dataframe
        tmp_table = table();
        
        %Grab id
        tmp_table.ID = id;
        
        %Grab y & u
        tmp_table.y = {out.y};
        tmp_table.u = {out.u};
        
        %Grab the options used or perhaps create a sub function to create this
        tmp_table.options = {out.options};
        
        vba_df = [vba_df; tmp_table];
    end
    
    %Save the data
    if ~exist([pwd filesep 'vba_mfx_input/'], 'dir')
        mkdir([pwd filesep 'vba_mfx_input/'])
    end
    
    save([pwd filesep 'vba_mfx_input/' sprintf('vba_mfx_input_%s',model{:})], 'vba_df');
end