import '../models/character.dart';

const characters = [
  Character(
    id: 'subaru',
    name: 'Natsuki Subaru',
    title: 'El héroe del retorno',
    image: 'assets/images/characters/subaru.jpg',
    bio:
        'Un joven japonés común y corriente que, de pronto, es invocado '
        'a otro mundo sin ninguna habilidad de combate. Su único poder es '
        'el Retorno por Muerte: cada vez que muere, regresa a un punto '
        'anterior en el tiempo, y solo él recuerda lo ocurrido. Con esa '
        'carga a cuestas, intenta salvar a quienes quiere sin rendirse.',
    traits: ['Retorno por Muerte', 'Terco', 'Leal'],
  ),
  Character(
    id: 'emilia',
    name: 'Emilia',
    title: 'La semielfa de cabello plateado',
    image: 'assets/images/characters/emilia.jpg',
    bio:
        'Una semielfa de cabello plateado que participa en la selección '
        'real para convertirse en gobernante del reino. Es amable y '
        'sincera, pero su apariencia despierta prejuicios en mucha gente. '
        'Es usuaria de espíritus y se convierte en la razón principal por '
        'la que Subaru no abandona.',
    traits: ['Magia de hielo', 'Bondadosa', 'Candidata real'],
  ),
  Character(
    id: 'rem',
    name: 'Rem',
    title: 'La criada oni',
    image: 'assets/images/characters/rem.jpg',
    bio:
        'Una criada de cabello azul que sirve en la mansión de Roswaal, '
        'junto a su hermana gemela Ram. Es eficiente, disciplinada y muy '
        'protectora con quienes aprecia. Con el tiempo, su relación con '
        'Subaru se vuelve una de las más queridas de la serie.',
    traits: ['Gran sentido del deber', 'Disciplinada', 'Devota'],
  ),
];
