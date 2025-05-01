hljs.highlightAll();
hljs.initLineNumbersOnLoad({
    singleLine: true
});
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('pre code').forEach(block => {
        const wrapper = document.createElement('div');
        wrapper.className = 'code-block-wrapper';
        block.parentNode.before(wrapper);
        wrapper.appendChild(block.parentNode);

        const lang = (block.className.match(/language-(\\w+)/)?.[1] || 'plaintext');
        if (lang === 'plaintext' || lang === 'text') {
            block.classList.add('nohljsln');
        } else {
            const langSpan = document.createElement('span');
            langSpan.className = 'code-language';
            langSpan.textContent = lang;
            wrapper.prepend(langSpan);

            const copyBtn = document.createElement('button');
            copyBtn.className = 'copy-button';
            copyBtn.textContent = 'Copy';
            copyBtn.onclick = () => {
                navigator.clipboard.writeText(block.textContent).then(() => {
                    copyBtn.textContent = 'Copied!';
                    setTimeout(() => copyBtn.textContent = 'Copy', 2000);
                });
            };
            wrapper.appendChild(copyBtn);
        }
    });
});