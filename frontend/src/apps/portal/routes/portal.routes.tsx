import React from 'react';
import { RouteObject } from 'react-router-dom';
import PortalLayout from '../layouts/PortalLayout';
import PortalHome from '../pages/PortalHome';

/**
 * Definição das rotas do novo Portal Corporativo.
 * Implementado em TypeScript seguindo a arquitetura multiempresa da New Wave.
 * 
 * Estas rotas são projetadas para serem integradas ao roteador principal da aplicação.
 */
export const portalRoutes: RouteObject[] = [
  {
    path: '/portal',
    element: <PortalLayout />,
    children: [
      {
        index: true,
        element: <PortalHome />,
      },
      /* 
        Módulos Reservados:
        Abaixo estão os placeholders para os módulos corporativos que serão 
        implementados de forma incremental conforme o cronograma do projeto.
      */
      {
        path: 'intranet',
        element: (
          <div className="portal-reserved-panel">
            <h2>Módulo de Intranet</h2>
            <p>Espaço reservado para comunicação institucional e feed corporativo.</p>
          </div>
        )
      },
      {
        path: 'treinamentos',
        element: (
          <div className="portal-reserved-panel">
            <h2>Módulo de Treinamentos</h2>
            <p>Espaço reservado para capacitação e trilhas de aprendizado.</p>
          </div>
        )
      },
      {
        path: 'documentos',
        element: (
          <div className="portal-reserved-panel">
            <h2>Gestão Documental</h2>
            <p>Espaço reservado para o repositório centralizado de documentos.</p>
          </div>
        )
      },
      {
        path: 'chamados',
        element: (
          <div className="portal-reserved-panel">
            <h2>Central de Chamados</h2>
            <p>Espaço reservado para suporte técnico e solicitações internas.</p>
          </div>
        )
      }
    ]
  }
];