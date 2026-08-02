export interface SenhaData {
  tipo: string;
  label: string;
}

export function printSenhaTicket(senhaData: SenhaData): void {
  try {
    const conteudo = `
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Senha - ${senhaData.tipo}</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        html, body {
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding-top: 10px;
        }
        body { font-family: Arial, sans-serif; }
        .comprovante {
            width: 280px;
            padding: 15px;
            text-align: center;
            border: 2px solid #000;
            margin: 0 auto;
        }
        .header {
            background: #000080;
            color: white;
            padding: 8px;
            margin: -15px -15px 15px -15px;
        }
        .header h1 { font-size: 12px; margin-bottom: 3px; }
        .header h2 { font-size: 10px; font-weight: normal; }
        .senha-numero {
            font-size: 42px;
            font-weight: bold;
            color: #000080;
            margin: 15px 0;
        }
        .senha-tipo {
            font-size: 16px;
            color: #333;
            margin-bottom: 15px;
        }
        .data-hora {
            font-size: 11px;
            color: #666;
            border-top: 1px dashed #ccc;
            padding-top: 12px;
            margin-top: 12px;
        }
        .aviso {
            font-size: 9px;
            color: #888;
            margin-top: 8px;
        }
        @page {
            margin: 0;
            size: auto;
        }
        @media print {
            html, body {
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }
            body {
                padding-top: 5mm;
            }
            .comprovante { border: none; }
        }
    </style>
</head>
<body>
    <div class="comprovante">
        <div class="header">
            <h1>PREFEITURA DE POÁ - SP</h1>
            <h2>PRONTO ATENDIMENTO DR GUIDO GUIDA</h2>
        </div>
        <div class="senha-numero">${senhaData.tipo}</div>
        <div class="senha-tipo">${senhaData.label || 'Senha de Atendimento'}</div>
        <div class="data-hora">
            ${new Date().toLocaleDateString('pt-BR')} - ${new Date().toLocaleTimeString('pt-BR')}
        </div>
        <div class="aviso">
            Acompanhe o painel de chamada
        </div>
    </div>
    <script>
        window.onload = function() {
            window.print();
            setTimeout(function() {
                window.close();
            }, 1000);
        };
    </script>
</body>
</html>
    `;

    const janelaImpressao = window.open('', '_blank', 'width=400,height=600')

    if (!janelaImpressao) {
      console.warn('Popup de impressão foi bloqueado pelo navegador')
      const printWindow = window.open('', '_blank')
      if (printWindow) {
        printWindow.document.write(conteudo)
        printWindow.document.close()
      }
      return
    }

    janelaImpressao.document.write(conteudo)
    janelaImpressao.document.close()
  } catch (err) {
    console.error('Erro ao imprimir senha:', err)
  }
}
