import java.util.Random;
import java.util.concurrent.Semaphore;


public class Practica1 {
    public enum Estat {
        FORA, ESPERANT, DINS
    }

    static final int MAX = 100;
    static final String[] noms = {"Joan", "Pere", "Anna", "Maria", "Josep"};
    static final int alumnes = noms.length;
    static int comptador_alumnes = 0;
    static int rondes = 3;
    static Semaphore sEntrar = new Semaphore(1);
    static Semaphore sDirector = new Semaphore(1);

    public static void main(String[] args) throws InterruptedException {

        new Practica1().inici();

    }

    public void inici() throws InterruptedException {


        System.out.println("SIMULACIÓ DE LA SALA D'ESTUDI");
        System.out.println("Nombre total de estudiants: " + noms.length);
        System.out.println("Nombre màxim d'estudiants a la sala: " + MAX);

        //Inicializam els threads
        Thread[] threads = new Thread[alumnes + 1];
        int t = 0;

        threads[t] = new Thread(new Director(t));
        t++;

        for (String nom : noms) {
            threads[t] = new Thread(new Estudiant(nom));
            t++;
        }


        for (int i = 0; i < alumnes + 1; i++) {
            threads[i].start();
        }
        for (int i = 0; i < alumnes + 1; i++) {
            threads[i].join();
        }

    }

    private class Director implements Runnable {
        private int id;
        public Estat estat;

        public Director(int id) {
            this.id = id;
            this.estat = Estat.FORA;
        }

        @Override
        public void run() {

            try {
                for (int i = 0; i < rondes; i++) {
                    System.out.println("El sr. Director comença la ronda");
                    if (comptador_alumnes == 0) {
                        System.out.println("El Director veu que no hi ha ningú a la sala d'estudis");

                    } else {
                        if (comptador_alumnes < MAX) {
                            this.estat = Estat.ESPERANT;
                            System.out.println("El Director està esperant per entrar. No molesta als que estudien");
                            sDirector.acquire();

                        } else {
                            //fiesta
                        }

                    }
                    if (comptador_alumnes == 0){
                        System.out.println("El Director veu que no hi ha ningú a la sala d'estudis");
                    }


                    Thread.sleep(new Random().nextInt(1000));
                    System.out.println("El Director acaba la ronda " + (i + 1) + " de + "+ rondes);
                    sDirector.release();
                    rondes++;
                }
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }


        }
    }


    private class Estudiant implements Runnable {
        private final String nom;

        public Estudiant(String nom) {
            this.nom = nom;
        }

        @Override
        public void run() {
            try {
                sDirector.acquire();
                sEntrar.acquire();
                comptador_alumnes++;
                sEntrar.release();
                System.out.println("L'estudiant " + this.nom + " entra a la sala. Total d'estudiants: " + comptador_alumnes);


                Thread.sleep(new Random().nextInt(2000));
                comptador_alumnes--;
                System.out.println("L'estudiant " + this.nom + " surt de la sala. Total d'estudiants: " + comptador_alumnes);
                if (comptador_alumnes == 0) {
                    System.out.println(nom + ": ADEU Senyor Director, pot entrar si vol, no hi ha ningú");
                    sDirector.release();
                }

            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }

    }
}