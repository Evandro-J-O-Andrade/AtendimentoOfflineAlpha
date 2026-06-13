import LoginForm from "@/components/auth/LoginForm";

/**
 * LoginLayout - New Wave Enterprise
 * Layout profissional com imagem nwlogin à esquerda.
 */
export default function LoginLayout() {
  return (
    <div className="min-h-screen flex bg-slate-950">

      {/* ESQUERDA */}
      <div className="hidden lg:flex lg:w-1/2 relative">

        <img
          src="/assets/img/nwlogin.png"
          alt="New Wave Enterprise"
          className="absolute inset-0 h-full w-full object-cover"
        />

        <div className="absolute inset-0 bg-gradient-to-r from-slate-950/90 via-slate-950/60 to-transparent" />

        <div className="relative z-10 flex flex-col justify-end p-16 text-white">

          <span className="text-cyan-400 uppercase tracking-[4px] font-semibold">
            New Wave Enterprise
          </span>

          <h1 className="text-6xl font-black mt-4 leading-tight">
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

      </div>

      {/* DIREITA */}
      <div className="flex-1 flex items-center justify-center bg-slate-950">

        <LoginForm />

      </div>

    </div>
  );
}