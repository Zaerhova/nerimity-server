module.exports = {
  hooks: {
    readPackage(pkg) {
      // This tells pnpm to trust these specific packages during the install
      const trusted = ['bcrypt', 'prisma', '@prisma/engines', 'esbuild', 'protobufjs', 'bufferutil', 'utf-8-validate', '@firebase/util'];

      if (trusted.includes(pkg.name)) {
        pkg.pnpm = pkg.pnpm || {};
        pkg.pnpm.neverBuiltDependencies = []; // Ensure they ARE allowed to build
      }
      return pkg;
    },
  },
};
