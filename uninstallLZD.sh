#!/bin/bash

echo "🧹 Désinstallation de Lazydocker (installation locale)..."

# Supprimer l'exécutable local
if [ -f "$HOME/.local/bin/lazydocker" ]; then
  rm "$HOME/.local/bin/lazydocker"
  echo "✅ Exécutable lazydocker supprimé de ~/.local/bin"
else
  echo "ℹ️ Aucun exécutable lazydocker trouvé dans ~/.local/bin"
fi

# Supprimer l'alias ld de ~/.zshrc
if grep -q "alias ld='lazydocker'" "$HOME/.zshrc"; then
  sed -i.bak "/alias ld='lazydocker'/d" "$HOME/.zshrc"
  echo "✅ Alias 'ld' supprimé de ~/.zshrc (backup : .zshrc.bak)"
else
  echo "ℹ️ Aucun alias 'ld' trouvé dans ~/.zshrc"
fi

# Supprimer la ligne PATH si elle a été ajoutée par le script
if grep -q 'export PATH="\$HOME/.local/bin:\$PATH"' "$HOME/.zshrc"; then
  sed -i '' '/export PATH="\$HOME\/.local\/bin:\$PATH"/d' "$HOME/.zshrc"
  echo "✅ Ligne PATH supprimée de ~/.zshrc"
fi

echo ""
echo "🔄 Recharge ton shell avec : source ~/.zshrc"
echo "🧼 Lazydocker a été supprimé proprement."
