import LoginForm from "@/components/auth/LoginForm";

/**
 * LoginLayout - New Wave Enterprise
 * Layout com imagem de fundo e formulário em overlay lateral
 * Dark mode elegante
 */
export default function LoginLayout() {
  return (
    <div className="min-h-screen relative">
      {/* Imagem de fundo full screen */}
      <img
        src="/assets/img/nwlogin.png"
        alt="New Wave Enterprise"
        className="absolute inset-0 h-full w-full object-cover"
      />

      {/* Overlay escuro gradiente */}
      <div className="absolute inset-0 bg-gradient-to-r from-slate-950/95 via-slate-950/80 to-slate-950/40 lg:to-transparent" />

      {/* Conteúdo */}
      <div className="relative z-10 min-h-screen flex">
        {/* Texto lateral esquerdo (desktop) */}
        <div className="hidden lg:flex lg:w-1/2 flex-col justify-center p-16 xl:p-24 text-white">
          <span className="text-cyan-400 uppercase tracking-[4px] font-semibold text-sm">
            New Wave Enterprise
          </span>
          <h1 className="text-5xl xl:text-6xl font-black mt-4 leading-tight">
            Enterprise
            <br />
            SaaS Platform
          </h1>
          <p className="mt-6 text-xl text-slate-300 max-w-xl">
            Plataforma corporativa para gestão,
            analytics, automação, operação
            e inteligência empresarial.
          </p>
        </div>

        {/* Formulário à direita */}
        <div className="w-full lg:w-1/2 flex items-center justify-center lg:justify-end p-8">
          <div className="w-full max-w-md lg:pr-16 xl:pr-24">
            <LoginForm />
          </div>
        </div>
      </div>
    </div>
  );
}