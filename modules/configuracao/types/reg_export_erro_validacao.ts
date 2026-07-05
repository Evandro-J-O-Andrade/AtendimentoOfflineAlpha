export interface RegExportErroValidacao {
  id_export_erro: number;
  id_export_item: number;
  id_export_arquivo: number;
  severidade: string;
  codigo: string;
  campo: string;
  mensagem: string;
  criado_em: string;
  id_entidade: number;
}

export interface RegExportErroValidacaoCreate {
  codigo?: string;
  campo?: string;
  mensagem?: string;
  criado_em?: string;
}

export interface RegExportErroValidacaoUpdate {
  codigo?: string;
  campo?: string;
  mensagem?: string;
  criado_em?: string;
}
