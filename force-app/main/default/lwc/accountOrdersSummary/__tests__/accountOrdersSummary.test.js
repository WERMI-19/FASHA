import { createElement } from 'lwc';
// Importer le bon composant
import AccountOrdersSummary from 'c/accountOrdersSummary';

describe('c-account-orders-summary', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('displays the component correctly', () => {
        // Arrange
        // Créer le bon composant
        const element = createElement('c-account-orders-summary', {
            is: AccountOrdersSummary
        });

        // Act
        document.body.appendChild(element);

        // Assert
        // On vérifie simplement que l'élément a bien été créé pour l'instant
        const div = element.shadowRoot.querySelector('div');
        expect(div).not.toBeNull();
    });
});