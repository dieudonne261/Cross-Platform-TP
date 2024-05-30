let data = [];

function loadData() {
    fetch('data.json')
        .then(response => response.json())
        .then(jsonData => {
            data = jsonData;
            displayData();
        })
        .catch(error => console.error('Erreur de chargement des données :', error));
}

function displayData(dataToDisplay = data) {
    const dataList = document.getElementById('data-list');
    dataList.innerHTML = '';
    const table = document.createElement('table');
    const headerRow = document.createElement('tr');
    ['NAME', 'EMAIL', 'DEVICE', 'ACTION'].forEach(header => {
        const th = document.createElement('th');
        th.textContent = header;
        headerRow.appendChild(th);
    });
    table.appendChild(headerRow);
    dataToDisplay.forEach(item => {
        const tr = document.createElement('tr');
        [item.name, item.email, item.devise].forEach(text => {
            const td = document.createElement('td');
            td.textContent = text;
            tr.appendChild(td);
        });

        const actionTd = document.createElement('td');
        const updateButton = document.createElement('button');
        updateButton.textContent = 'Update';
        updateButton.onclick = () => updateEntry(item.id);
        const deleteButton = document.createElement('button');
        deleteButton.textContent = 'Delete';
        deleteButton.onclick = () => deleteEntry(item.id);
        actionTd.appendChild(updateButton);
        actionTd.appendChild(deleteButton);
        tr.appendChild(actionTd);

        table.appendChild(tr);
    });

    dataList.appendChild(table);
}




function addEntry(name, email, devise) {
    const newEntry = {
        name: name,
        email: email,
        devise: devise
    };
    data.push(newEntry);
    displayData();
}

function deleteEntry(id) {
    const index = data.findIndex(item => item.id === id);
    if (index !== -1) {
        data.splice(index, 1);
        displayData();
    }
}

function updateEntry(id) {
    const item = data.find(item => item.id === id);
    if (item) {
        openModal('update', item);
    }
}

function openModal(action, item) {
    const modal = document.getElementById('modal');
    modal.style.display = 'block';
    const modalContent = document.querySelector('.modal-content');
    if (action === 'add') {
        modalContent.innerHTML = `
            <h2>Ajouter une nouvelle entrée</h2>
            <input type="text" id="name" placeholder="Nom">
            <input type="text" id="email" placeholder="Email">
            <input type="text" id="devise" placeholder="Devise">
            <button onclick="saveEntry()">Enregistrer</button>
        `;
    } else if (action === 'update' && item) {
        modalContent.innerHTML = `
            <h2>Mettre à jour l'entrée</h2>
            <input type="text" id="name" placeholder="Nom" value="${item.name}">
            <input type="text" id="email" placeholder="Email" value="${item.email}">
            <input type="text" id="devise" placeholder="Devise" value="${item.devise}">
            <button onclick="saveUpdatedEntry(${item.id})">Enregistrer</button>
        `;
    }
}

function saveUpdatedEntry(id) {
    const name = document.getElementById('name').value;
    const email = document.getElementById('email').value;
    const devise = document.getElementById('devise').value;
    const index = data.findIndex(item => item.id === id);
    if (index !== -1) {
        data[index] = { id: id, name: name, email: email, devise: devise };
        displayData();
        closeModal();
    } else {
        console.error('ID non trouvé :', id);
    }
}

function closeModal() {
    const modal = document.getElementById('modal');
    modal.style.display = 'none';
}

function saveEntry() {
    const name = document.getElementById('name').value;
    const email = document.getElementById('email').value;
    const devise = document.getElementById('devise').value;
    addEntry(name, email, devise);
    closeModal();
}

function searchData() {
    const query = document.getElementById('search-query').value;
    const filteredData = data.filter(item => {
        return item.name.toLowerCase().includes(query.toLowerCase()) ||
               item.email.toLowerCase().includes(query.toLowerCase()) ||
               item.devise.toLowerCase().includes(query.toLowerCase());
    });
    displayData(filteredData);
}

loadData();
