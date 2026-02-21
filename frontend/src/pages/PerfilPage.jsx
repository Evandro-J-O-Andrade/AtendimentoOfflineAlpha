// ========================================================
// Perfil Page - Perfil do Usuário
// ========================================================
import { User, Mail, Phone, MapPin } from 'lucide-react';
import { useAuth } from '../hooks/useAuth';

export default function PerfilPage() {
  const { usuario } = useAuth();

  if (!usuario) {
    return <div>Carregando...</div>;
  }

  return (
    <div className="p-6 max-w-3xl mx-auto">
      <h1 className="text-3xl font-bold text-gray-900 mb-6">Meu Perfil</h1>

      <div className="bg-white rounded-lg shadow-sm p-8">
        {/* Header with Avatar */}
        <div className="flex items-start gap-6 mb-8 pb-8 border-b border-gray-200">
          <div className="w-20 h-20 bg-blue-100 rounded-full flex items-center justify-center text-3xl font-bold text-blue-600">
            {usuario.nome?.[0]?.toUpperCase() || 'U'}
          </div>
          <div>
            <h2 className="text-2xl font-bold text-gray-900">{usuario.nome}</h2>
            <p className="text-gray-600">Perfil: {usuario.perfil_nome || usuario.role}</p>
            <p className="text-sm text-gray-500 mt-1">ID: {usuario.id}</p>
          </div>
        </div>

        {/* User Information */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
          {/* Email */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Email</label>
            <div className="flex items-center gap-3 px-4 py-3 bg-gray-50 rounded-lg">
              <Mail className="w-5 h-5 text-gray-400" />
              <span className="text-gray-900">{usuario.email}</span>
            </div>
          </div>

          {/* Phone (if available) */}
          {usuario.telefone && (
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">Telefone</label>
              <div className="flex items-center gap-3 px-4 py-3 bg-gray-50 rounded-lg">
                <Phone className="w-5 h-5 text-gray-400" />
                <span className="text-gray-900">{usuario.telefone}</span>
              </div>
            </div>
          )}

          {/* Registration Date */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Data de Registro</label>
            <div className="px-4 py-3 bg-gray-50 rounded-lg text-gray-900">
              {usuario.data_criacao
                ? new Date(usuario.data_criacao).toLocaleDateString('pt-BR')
                : '-'}
            </div>
          </div>
        </div>

        {/* Action Buttons */}
        <div className="flex gap-3 pt-6 border-t border-gray-200">
          <button className="btn-primary">Editar Perfil</button>
          <button className="btn-secondary">Alterar Senha</button>
        </div>
      </div>
    </div>
  );
}
