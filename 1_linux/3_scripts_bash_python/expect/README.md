# Expect examples

- [`ssh-kras.exp.sh`](ssh-kras.exp.sh) — исходный рабочий пример с переменными
  `PASS` и `MY_USER`. Его содержимое сохранено без изменений.
- [`expect.sh`](expect.sh) — исходные заметки и пример настройки alias.
- [`ssh-interactive-sudo.exp`](ssh-interactive-sudo.exp) — дополнительный
  вариант, в котором SSH и `sudo` сами обрабатывают authentication prompts, а
  Expect только запускает интерактивную сессию и возвращает её exit status.

Новый вариант не заменяет исходный:

```bash
expect ./ssh-interactive-sudo.exp server.example admin_user

# Или с пользователем из environment
SSH_USER=admin_user expect ./ssh-interactive-sudo.exp server.example
```

Для постоянной automation предпочтительнее SSH keys, certificates или
централизованный access proxy. Проверяйте host fingerprint до первого
подключения к критичной системе.
