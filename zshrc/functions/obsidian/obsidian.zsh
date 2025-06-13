# ~/.zshrc에서 source 될 파일
# /Users/gu/Repos/Utils/zshrc/functions/obsidian/obsidian.zsh

function obsidian() {
  TEMPLATE_DIR="$(dirname "${(%):-%x}")/template/.obsidian"
  MEMO_ROOT="${MEMO:-$HOME/Repos/memos}"

  if [[ "$1" == "init" ]]; then
    TARGET_DIR="$(pwd)/.obsidian"

    if [[ -d "$TARGET_DIR" ]]; then
      mv "$TARGET_DIR" "${TARGET_DIR}_backup_$(date +%s)"
      echo "📦 기존 .obsidian 백업 완료"
    fi

    cp -R "$TEMPLATE_DIR" "$TARGET_DIR"
    echo "✅ Obsidian 템플릿 복사 완료: $TARGET_DIR"

  elif [[ "$1" == "apply" && "$2" == "template" ]]; then

    if [[ "$3" == "." ]]; then
      TARGET_DIR="$(pwd)/.obsidian"
      if [[ -d "$TARGET_DIR" ]]; then
        cp -R "$TEMPLATE_DIR/" "$TARGET_DIR/"
        echo "✅ 템플릿 적용 완료: $TARGET_DIR"
      else
        echo "⚠️ .obsidian 디렉터리가 존재하지 않아 적용 생략"
      fi

    elif [[ "$3" == "all" ]]; then
      find "$MEMO_ROOT" -type d -name ".obsidian" | while read -r dir; do
        skip=0
        for exclude in "${EXCLUDE_DIRS[@]}"; do
          if [[ "$dir" == "$MEMO_ROOT/$exclude"* ]]; then
            skip=1
            break
          fi
        done

        if [[ $skip -eq 0 ]]; then
          cp -R "$TEMPLATE_DIR/" "$dir/"
          echo "✅ 템플릿 적용: $dir"
        else
          echo "⏭️ 예외 처리로 스킵됨: $dir"
        fi
      done
    else
      echo "Usage: obsidian apply template [ . | all ]"
    fi

  else
    echo "Usage:"
    echo "  obsidian init"
    echo "  obsidian apply template ."
    echo "  obsidian apply template all"
  fi
}