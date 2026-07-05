export interface EstoqueExecucaoPipeline {
  pipeline_hash: string;
  estado: string;
  id_entidade: number;
}

export interface EstoqueExecucaoPipelineCreate {
  pipeline_hash?: string;
  estado?: string;
}

export interface EstoqueExecucaoPipelineUpdate {
  pipeline_hash?: string;
  estado?: string;
}
