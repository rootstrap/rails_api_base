import * as esbuild from 'esbuild'

const config = {
  entryPoints: ['app/assets/javascripts/active_admin.js'],
  bundle: true,
  sourcemap: true,
  minify: process.env.RAILS_ENV == "production",
  outdir: 'app/assets/builds',
  publicPath: '/assets'
}

if (process.argv.includes("--watch")) {
  let context = await esbuild.context({...config, logLevel: 'info'})
  context.watch()
} else {
  esbuild.build(config)
}
