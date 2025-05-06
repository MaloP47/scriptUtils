#!/bin/bash

echo "📦 Installation de Lazydocker (user local)..."

# Crée le dossier ~/.local/bin si besoin
mkdir -p "$HOME/.local/bin"

# Téléchargement de la dernière version
LAZYDOCKER_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazydocker/releases/latest | grep tag_name | cut -d '"' -f 4)
curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/download/${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION#v}_Linux_x86_64.tar.gz"
tar xf lazydocker.tar.gz
mv lazydocker "$HOME/.local/bin/"
rm lazydocker.tar.gz

echo "✅ Lazydocker installé dans ~/.local/bin"

# Ajouter ~/.local/bin au PATH si ce n'est pas déjà fait
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
  echo "🔧 PATH mis à jour dans ~/.zshrc"
fi

# Ajout de l'alias
if ! grep -q "alias ld=" "$HOME/.zshrc"; then
  echo "alias ld='lazydocker'" >> "$HOME/.zshrc"
  echo "✅ Alias 'ld' ajouté à ~/.zshrc"
else
  echo "ℹ️ Alias 'ld' déjà présent"
fi

echo ""
echo "🔄 Recharge ton shell avec : source ~/.zshrc"
echo "🚀 Puis lance : ld"
