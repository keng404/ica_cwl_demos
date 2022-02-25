#!/usr/bin/env cwl-runner
$namespaces:
  ilmn-tes: http://platform.illumina.com/rdf/iap/
cwlVersion: cwl:v1.0
class: CommandLineTool
hints:
    DockerRequirement:
        dockerPull: keng404/tso500_solid:latest
requirements:
    - class: ResourceRequirement
      https://platform.illumina.com/rdf/iap/resources: 
        type: standardhimem 
        size: 8xlarge
    - class: InlineJavascriptRequirement
    - class: InitialWorkDirRequirement
      listing:
      - entry: "if [ -z $8  ] \nthen\n    python /modified_workflows/run_tso500_solid.py --samplesheet\
            \ $1 --output_directory $(runtime.outdir)/$(inputs.output_directory_root) --resource_directory\
            \ $(runtime.outdir)/$(inputs.resource_dir.basename)/resources --run_directory $(runtime.outdir)/$(inputs.run_directory.basename)\
            \ $4 $5 $6 $7\nelse\n    python /modified_workflows/run_tso500_solid.py --samplesheet\
            \ $1 --output_directory $(runtime.outdir)/$(inputs.output_directory_root) --resource_directory\
            \ $(runtime.outdir)/$(inputs.resource_dir.basename)/resources --run_directory $(runtime.outdir)/$(inputs.run_directory.basename)\
            \ $4 $5 $6 $7 $8\nfi\n\ncat /modified_workflows/tso500.input.json\nrm -rf $(runtime.outdir)/$(inputs.run_directory_tar.basename)\n"
        entryname: run_tso500_solid.sh
        writable: false
label: tso500_solid_cli_native
inputs:
  samplesheet:
    type: File
    inputBinding:
      position: 1
  resource_dir:
    type: Directory
    inputBinding:
      position: 3
  run_directory:
    type: Directory
    inputBinding:
      position: 4
  output_directory_root:
    type: string
  demultiplex:
    type:
    - string
    - 'null'
  single_lane_mode:
    type:
    - string
    - 'null'
  novaseq:
    type:
    - string
    - 'null'
  first_tile_only:
    type:
    - string
    - 'null'
  sample_pairs_only:
    type:
    - string
    - 'null'
    doc: 'Optional. Provide the comma delimited Sample Pair IDs that should be processed
      on this node, ie: "Pair_1,Pair_2,Sample_1"'
outputs:
  analysis_results:
    type:
    - Directory
    - 'null'
    outputBinding:
      glob:
      - $(runtime.outdir)/$(inputs.output_directory_root)
arguments:
- position: 5
  valueFrom: ${if(inputs.demultiplex == "False") return ' --demultiplex False'; else
    return ' --demultiplex True'}
- position: 6
  valueFrom: ${ if(inputs.single_lane_mode == "True") return ' --single_lane_mode
    True'; else return ' --single_lane_mode False'}
- position: 7
  valueFrom: ${if(inputs.novaseq == "True") return ' --novaseq True'; else return
    ' --novaseq False'}
- position: 8
  valueFrom: ${if(inputs.first_tile_only == "True") return ' --first_tile_only True';
    else return ' --first_tile_only False'}
- position: 9
  valueFrom: ${var args = []; if(inputs.sample_pair_ids){  args.push('--sample_pair_ids');
    args.push(inputs.sample_pair_ids); } return args}
baseCommand:
- bash
- run_tso500_solid.sh