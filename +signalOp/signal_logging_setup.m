function signal_logging_setup(sys)
%SIGNAL_LOGGING_SETUP Summary of this function goes here
%   Detailed explanation goes here
all_blocks = signalOp.get_all_top_level_blocks(sys);
            
for i = 1:numel(all_blocks)
    if strcmp(get_param(all_blocks(i), 'blocktype'), 'If')
        continue;
    end
    port_handles = get_param(all_blocks(i), 'PortHandles');
    out_ports = port_handles.Outport;

    for j = 1: numel(out_ports)
        set_param(out_ports(j), 'DataLogging', 'On','TestPoint','on');
    end
end
end

