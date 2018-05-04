function [p_sub,o_sub,p_group,o_group] = run_trust_vba_mfx(vba_df)

%Ensure the vba evo and observation functions are on path
addpath('vba_funcitons\')

%Parse out the vba dataframe
y = vba_df.y;
u = vba_df.u;

models = {'f_trust_Qlearn_policy'};

% %VBA mfx does not like unequal trials, bring this up to Alex
% %Find which index have less than max trials
% trial_lengths = cellfun(@length,vba_df.y);
% missing_data_index = find(max(trial_lengths) > trial_lengths);
% 
% %Remove missing subjects 
% y(missing_data_index) = [];
% u(missing_data_index) = [];

for model = models
    
    close all; %Get rid of extensive gpu memory figs
    
    %Load i nthe options per model
    load(sprintf('vba_mfx_input/vba_mfx_input_%s.mat',model{:}))
    options = vba_df.options;
    
    %Ensure that options.hf (graphic handle) is non exsistent and
    %DisplayWin is set to 0
%     options=cellfun(@(x) {rmfield(x,'hf')}, options);
%     options=cellfun(@(x) {setfield(x,'DisplayWin',0)}, options);
        
    %Initialize the output matrix
    vba_mfx_df = table();
    
    %Load in the options 
    dim = vba_df.options{1}.dim;
    
    %options(missing_data_index) = [];
    
    %Designate the f and g function handles
    f_name = vba_df.options{1}.f_fname; %Evolution function
    g_name = vba_df.options{1}.g_fname; %Observation function

    %clear vars for new output
    clearvars p_sub o_sub p_group o_group
    
    %[p_sub,o_sub,p_group,o_group] = VBA_MFX(y,u,f_fname,g_fname,dim,options,priors_group);
    [p_sub,o_sub,p_group,o_group] = VBA_MFX(y,u,f_name,g_name,dim,options);
    
    %Save uncompressed albeit they will be large
    save(sprintf('E:/data/sceptic/vba_out/explore_clock/vba_mfx_input/vba_mfx_output_p_sub_%s',model{:}),'p_sub', '-v7.3')
    save(sprintf('E:/data/sceptic/vba_out/explore_clock/vba_mfx_input/vba_mfx_output_o_sub_%s',model{:}),'o_sub', '-v7.3')
    save(sprintf('E:/data/sceptic/vba_out/explore_clock/vba_mfx_input/vba_mfx_output_p_group_%s',model{:}),'p_group', '-v7.3')
    save(sprintf('E:/data/sceptic/vba_out/explore_clock/vba_mfx_input/vba_mfx_output_o_group_%s',model{:}),'o_group', '-v7.3')
    
end